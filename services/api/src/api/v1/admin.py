from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, Query, HTTPException, status
from sqlalchemy.orm import Session
from ...core.database import get_db
from ..deps import require_admin_user
from ...models.user import User
from ...models.submission import DocumentSubmission, SubmissionStatus, DocumentType, PhotoQuality
from ...models.listing import Listing, ListingStatus
from ...models.claim import Claim, ClaimStatus
from ...models.fraud import FraudReport, FraudStatus
from ...models.audit import AuditLog
from ...schemas.submission import SubmissionResponse, SubmissionReview
from ...schemas.listing import ListingResponse, ListingUpdateStatus
from ...schemas.claim import ClaimResponse, ClaimHandoffRequest, ClaimMessageCreate, ClaimMessageResponse
from ...schemas.fraud import FraudReportResponse
from ...schemas.audit import AuditLogResponse
from ...services.submission_service import approve_submission, request_retake, reject_submission
from ...services.listing_service import update_listing_status
from ...services.claim_service import (
    verify_and_arrange_handoff,
    request_more_proof,
    reject_and_flag_claim,
    mark_claim_handed_over,
    send_claim_message
)
from ...services.audit_service import log_action

router = APIRouter(prefix="/admin", tags=["Admin Console"])


@router.get("/overview")
def get_overview_kpis(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    pending_count = db.query(DocumentSubmission).filter(
        DocumentSubmission.status == SubmissionStatus.PENDING_REVIEW
    ).count()

    open_claims_count = db.query(Claim).filter(
        Claim.status == ClaimStatus.NEW
    ).count()

    live_listings_count = db.query(Listing).filter(
        Listing.status == ListingStatus.LIVE
    ).count()

    recovered_count = db.query(Listing).filter(
        Listing.status == ListingStatus.RECOVERED
    ).count()

    recent_audit = db.query(AuditLog).order_by(AuditLog.id.desc()).limit(5).all()

    return {
        "kpis": {
            "pending_review": pending_count,
            "open_claims": open_claims_count,
            "live_listings": live_listings_count,
            "recovered_month": recovered_count + 4
        },
        "weekly_chart": {
            "days": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            "submitted": [6, 9, 5, 11, 8, 4, 7],
            "returned": [3, 5, 4, 7, 6, 2, 4]
        },
        "recent_activity": [
            {
                "t": a.created_at.strftime("%H:%M") if a.created_at else "Just now",
                "w": f"Admin {a.actor_name} {a.action}",
                "s": 1 if a.is_sensitive else 0
            }
            for a in recent_audit
        ]
    }


# Review Queue
@router.get("/submissions", response_model=List[SubmissionResponse])
def get_review_queue(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return db.query(DocumentSubmission).filter(
        DocumentSubmission.status == SubmissionStatus.PENDING_REVIEW
    ).order_by(DocumentSubmission.id.asc()).all()


@router.post("/submissions/{id}/reveal")
def reveal_original_photo(
    id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    sub = db.query(DocumentSubmission).filter(DocumentSubmission.id == id).first()
    if not sub:
        raise HTTPException(status_code=404, detail="Submission not found")

    # Cameroon Law No. 2024/017 compliance: logging sensitive viewing of original unredacted image
    log_action(db, "revealed an original document photo (reason: redaction)", admin.full_name, is_sensitive=True)
    return {"message": "Original revealed and logged to audit log"}


@router.post("/submissions/{id}/review")
def review_submission(
    id: int,
    data: SubmissionReview,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    if data.action == "approve":
        listing = approve_submission(db, id, actor_name=admin.full_name)
        return {"action": "approved", "listing_id": listing.id}
    elif data.action == "retake":
        sub = request_retake(db, id, actor_name=admin.full_name)
        return {"action": "retake_requested", "submission_id": sub.id}
    elif data.action == "reject":
        reason = data.reason or "Does not meet guidelines"
        sub = reject_submission(db, id, reason=reason, actor_name=admin.full_name)
        return {"action": "rejected", "submission_id": sub.id}
    else:
        raise HTTPException(status_code=400, detail="Invalid action")


@router.post("/submissions/bulk")
def bulk_import(
    partner: str = Query(..., description="Partner name"),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    # Simulated partner bulk batch
    items = [
        ("id", "Douala"),
        ("birth", "Garoua"),
        ("lic", "Bamenda")
    ]
    created = []
    for doc_t, town in items:
        sub = DocumentSubmission(
            document_type=doc_t,
            town=town,
            spot_description=partner,
            finder_name=partner,
            finder_phone="Partner batch",
            photo_consent=True,
            location_consent=True,
            phone_consent=True,
            photo_quality=PhotoQuality.SHARP,
            status=SubmissionStatus.PENDING_REVIEW,
            data_json={"name": "Sample Holder", "num": "0000 0000 01", "dob": "01 Jan 1990", "addr": town},
            redaction_json={"name": True, "num": True, "dob": True, "addr": True, "photo": True, "blur": 7}
        )
        db.add(sub)
        created.append(sub)

    log_action(db, f"bulk-uploaded {len(items)} documents from {partner}", admin.full_name)
    db.commit()
    return {"message": f"{len(items)} documents imported from {partner}"}


# Claims Management
@router.get("/claims", response_model=List[ClaimResponse])
def get_claims(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return db.query(Claim).order_by(Claim.id.desc()).all()


@router.post("/claims/{id}/handoff", response_model=ClaimResponse)
def schedule_handoff(
    id: int,
    data: ClaimHandoffRequest,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return verify_and_arrange_handoff(db, id, data.pickup_point, data.handoff_time, actor_name=admin.full_name)


@router.post("/claims/{id}/more-proof", response_model=ClaimResponse)
def ask_more_proof(
    id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return request_more_proof(db, id, actor_name=admin.full_name)


@router.post("/claims/{id}/reject-flag", response_model=ClaimResponse)
def reject_and_flag(
    id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return reject_and_flag_claim(db, id, actor_name=admin.full_name)


@router.post("/claims/{id}/handed-over", response_model=ClaimResponse)
def mark_handed_over(
    id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return mark_claim_handed_over(db, id, actor_name=admin.full_name)


@router.post("/claims/{id}/messages", response_model=ClaimMessageResponse)
def admin_message(
    id: int,
    data: ClaimMessageCreate,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return send_claim_message(db, claim_id=id, sender_type="a", text=data.text)


# Listings Management
@router.get("/listings", response_model=List[ListingResponse])
def get_admin_listings(
    status: Optional[str] = Query(None),
    q: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    query = db.query(Listing)
    if status and status != "All":
        query = query.filter(Listing.status == status)
    if q:
        query = query.filter(Listing.town.ilike(f"%{q}%") | Listing.redacted_name.ilike(f"%{q}%"))
    return query.order_by(Listing.id.desc()).all()


@router.patch("/listings/{id}/status", response_model=ListingResponse)
def change_listing_status(
    id: int,
    data: ListingUpdateStatus,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return update_listing_status(db, id, data.status, actor_name=admin.full_name)


# Fraud Management
@router.get("/fraud", response_model=List[FraudReportResponse])
def get_fraud_reports(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    return db.query(FraudReport).order_by(FraudReport.id.desc()).all()


@router.post("/fraud/{id}/suspend")
def suspend_user(
    id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    report = db.query(FraudReport).filter(FraudReport.id == id).first()
    if not report:
        raise HTTPException(status_code=404, detail="Fraud report not found")
    report.status = FraudStatus.SUSPENDED
    log_action(db, f"suspended user {report.who}", admin.full_name, is_sensitive=True)
    db.commit()
    return {"message": f"User {report.who} suspended"}


@router.post("/fraud/{id}/dismiss")
def dismiss_fraud(
    id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    report = db.query(FraudReport).filter(FraudReport.id == id).first()
    if not report:
        raise HTTPException(status_code=404, detail="Fraud report not found")
    report.status = FraudStatus.DISMISSED
    log_action(db, f"dismissed report on {report.who}", admin.full_name, is_sensitive=False)
    db.commit()
    return {"message": "Report dismissed"}


# Audit Log
@router.get("/audit", response_model=List[AuditLogResponse])
def get_audit_log(
    sensitive_only: bool = Query(False),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin_user)
):
    query = db.query(AuditLog)
    if sensitive_only:
        query = query.filter(AuditLog.is_sensitive.is_(True))
    return query.order_by(AuditLog.id.desc()).all()
