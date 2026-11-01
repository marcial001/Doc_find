from typing import List, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException
from ..models.claim import Claim, ClaimStatus, ClaimMessage, ClaimRisk
from ..models.listing import Listing, ListingStatus
from ..models.fraud import FraudReport, FraudSeverity, FraudStatus
from ..schemas.claim import ClaimCreate
from .redaction_service import evaluate_proof_answer
from .audit_service import log_action
from .submission_service import DOCUMENT_TYPE_LABELS


def create_claim(
    db: Session,
    data: ClaimCreate,
    claimant_id: Optional[int] = None
) -> Claim:
    listing = db.query(Listing).filter(Listing.id == data.listing_id).first()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")

    holder_name = (
        listing.submission.data_json.get("name", "")
        if listing.submission else listing.redacted_name
    )

    is_matched, risk, signals = evaluate_proof_answer(
        expected_answer=listing.expected_answer,
        submitted_answer=data.submitted_answer,
        claimant_name=data.claimant_name,
        doc_holder_name=holder_name,
        has_id_photo=data.has_id_photo
    )

    claim = Claim(
        listing_id=listing.id,
        claimant_id=claimant_id,
        claimant_name=data.claimant_name,
        claimant_phone=data.claimant_phone,
        submitted_answer=data.submitted_answer,
        is_matched=is_matched,
        has_id_photo=data.has_id_photo,
        risk_level=risk,
        risk_signals=signals,
        status=ClaimStatus.NEW
    )
    db.add(claim)

    listing.claims_count += 1

    # Add initial greeting message
    init_msg = ClaimMessage(
        claim=claim,
        sender_type="u",
        text=f"Hello, I am claiming my {DOCUMENT_TYPE_LABELS.get(listing.document_type, 'document')}."
    )
    db.add(init_msg)

    db.commit()
    db.refresh(claim)
    return claim


def send_claim_message(
    db: Session,
    claim_id: int,
    sender_type: str,
    text: str
) -> ClaimMessage:
    claim = db.query(Claim).filter(Claim.id == claim_id).first()
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")

    msg = ClaimMessage(
        claim_id=claim.id,
        sender_type=sender_type,
        text=text
    )
    db.add(msg)
    db.commit()
    db.refresh(msg)
    return msg


def verify_and_arrange_handoff(
    db: Session,
    claim_id: int,
    pickup_point: str,
    handoff_time: str,
    actor_name: str = "Admin Antony"
) -> Claim:
    claim = db.query(Claim).filter(Claim.id == claim_id).first()
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")

    claim.status = ClaimStatus.HANDOFF
    claim.handoff_location = pickup_point
    claim.handoff_time = handoff_time

    # Add official handoff message to claimant thread
    hand_msg = ClaimMessage(
        claim_id=claim.id,
        sender_type="a",
        text=f"Your claim is verified. Please come to {pickup_point} on {handoff_time} with your original ID."
    )
    db.add(hand_msg)

    doc_label = DOCUMENT_TYPE_LABELS.get(claim.listing.document_type, "Document")
    log_action(db, f"verified claim and scheduled handoff: {doc_label} · {claim.listing.town}", actor_name)

    db.commit()
    db.refresh(claim)
    return claim


def request_more_proof(
    db: Session,
    claim_id: int,
    actor_name: str = "Admin Antony"
) -> Claim:
    claim = db.query(Claim).filter(Claim.id == claim_id).first()
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")

    claim.status = ClaimStatus.MORE
    more_msg = ClaimMessage(
        claim_id=claim.id,
        sender_type="a",
        text="Please send a clear photo of your own ID so we can confirm."
    )
    db.add(more_msg)

    log_action(db, f"requested more proof from {claim.claimant_name}", actor_name)
    db.commit()
    db.refresh(claim)
    return claim


def reject_and_flag_claim(
    db: Session,
    claim_id: int,
    actor_name: str = "Admin Antony"
) -> Claim:
    claim = db.query(Claim).filter(Claim.id == claim_id).first()
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")

    claim.status = ClaimStatus.REJECTED
    rej_msg = ClaimMessage(
        claim_id=claim.id,
        sender_type="a",
        text="We could not verify this claim, so we cannot release the document."
    )
    db.add(rej_msg)

    doc_label = DOCUMENT_TYPE_LABELS.get(claim.listing.document_type, "Document")

    # Add to Fraud reports
    report = FraudReport(
        who=claim.claimant_name,
        why=f"Claim rejected for {doc_label}: proof did not match.",
        source_by="Admin flag",
        severity=FraudSeverity.HIGH if claim.risk_level == ClaimRisk.HIGH else FraudSeverity.MEDIUM,
        status=FraudStatus.OPEN
    )
    db.add(report)

    # Sensitive audit log
    log_action(db, f"rejected claim and flagged {claim.claimant_name}", actor_name, is_sensitive=True)

    db.commit()
    db.refresh(claim)
    return claim


def mark_claim_handed_over(
    db: Session,
    claim_id: int,
    actor_name: str = "Admin Antony"
) -> Claim:
    claim = db.query(Claim).filter(Claim.id == claim_id).first()
    if not claim:
        raise HTTPException(status_code=404, detail="Claim not found")

    claim.status = ClaimStatus.DONE
    if claim.listing:
        claim.listing.status = ListingStatus.RECOVERED

    doc_label = DOCUMENT_TYPE_LABELS.get(claim.listing.document_type, "Document")
    log_action(db, f"marked handed over: {doc_label} · {claim.listing.town}", actor_name)

    db.commit()
    db.refresh(claim)
    return claim
