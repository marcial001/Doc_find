from typing import List, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from ..models.submission import DocumentSubmission, SubmissionStatus, DocumentType
from ..models.listing import Listing, ListingStatus
from ..schemas.submission import SubmissionCreate, SubmissionReview
from .redaction_service import mask_name, get_default_secret_question
from .audit_service import log_action

DOCUMENT_TYPE_LABELS = {
    DocumentType.ID: "ID card",
    DocumentType.PASS: "Passport",
    DocumentType.BIRTH: "Birth certificate",
    DocumentType.LIC: "Driver’s licence",
    DocumentType.OTHER: "Student card"
}


def create_submission(
    db: Session,
    data: SubmissionCreate,
    finder_id: Optional[int] = None
) -> DocumentSubmission:
    # Strictly enforce Law No. 2024/017 consents
    if not data.photo_consent or not data.location_consent:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Photo and location consent (Law No. 2024/017) are required to submit a found document."
        )

    redaction_dict = data.redactions.model_dump() if data.redactions else {
        "name": True,
        "num": True,
        "dob": True,
        "addr": True,
        "photo": True,
        "blur": 7
    }

    submission = DocumentSubmission(
        finder_id=finder_id,
        document_type=data.document_type,
        town=data.town,
        spot_description=data.spot_description,
        finder_name=data.finder_name,
        finder_phone=data.finder_phone,
        photo_consent=data.photo_consent,
        location_consent=data.location_consent,
        phone_consent=data.phone_consent,
        photo_quality=data.photo_quality,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json=data.data.model_dump(),
        redaction_json=redaction_dict
    )
    db.add(submission)
    db.commit()
    db.refresh(submission)
    return submission


def approve_submission(
    db: Session,
    submission_id: int,
    actor_name: str = "Admin Antony"
) -> Listing:
    sub = db.query(DocumentSubmission).filter(DocumentSubmission.id == submission_id).first()
    if not sub:
        raise HTTPException(status_code=404, detail="Submission not found")

    if not sub.photo_consent or not sub.location_consent:
        raise HTTPException(
            status_code=400,
            detail="Photo and location consent required to publish."
        )

    sub.status = SubmissionStatus.APPROVED

    # Extract holder name and generate masked name
    raw_name = sub.data_json.get("name", "Document Holder")
    redacted_name = mask_name(raw_name)

    # Determine secret verification question and expected answer
    secret_question = get_default_secret_question(sub.document_type)
    if sub.document_type == DocumentType.ID:
        expected_answer = sub.town
    elif sub.document_type == DocumentType.PASS:
        expected_answer = sub.data_json.get("dob", "")
    elif sub.document_type == DocumentType.BIRTH:
        expected_answer = sub.data_json.get("name", "").split()[0]
    else:
        expected_answer = sub.data_json.get("dob", "")

    listing = Listing(
        submission_id=sub.id,
        document_type=sub.document_type,
        town=sub.town,
        spot_description=sub.spot_description,
        redacted_name=redacted_name,
        status=ListingStatus.LIVE,
        views_count=0,
        claims_count=0,
        days_online=0,
        secret_question=secret_question,
        expected_answer=expected_answer
    )
    db.add(listing)

    doc_label = DOCUMENT_TYPE_LABELS.get(sub.document_type, "Document")
    log_action(db, f"approved listing: {doc_label} · {sub.town}", actor_name)

    db.commit()
    db.refresh(listing)
    return listing


def request_retake(
    db: Session,
    submission_id: int,
    actor_name: str = "Admin Antony"
) -> DocumentSubmission:
    sub = db.query(DocumentSubmission).filter(DocumentSubmission.id == submission_id).first()
    if not sub:
        raise HTTPException(status_code=404, detail="Submission not found")

    doc_label = DOCUMENT_TYPE_LABELS.get(sub.document_type, "Document")
    log_action(db, f"asked finder for a better photo: {doc_label} · {sub.town}", actor_name)
    return sub


def reject_submission(
    db: Session,
    submission_id: int,
    reason: str,
    actor_name: str = "Admin Antony"
) -> DocumentSubmission:
    sub = db.query(DocumentSubmission).filter(DocumentSubmission.id == submission_id).first()
    if not sub:
        raise HTTPException(status_code=404, detail="Submission not found")

    sub.status = SubmissionStatus.REJECTED
    sub.reject_reason = reason

    log_action(db, f"rejected submission ({reason})", actor_name)
    db.commit()
    db.refresh(sub)
    return sub
