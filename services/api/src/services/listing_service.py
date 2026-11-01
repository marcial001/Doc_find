from typing import List, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException
from ..models.listing import Listing, ListingStatus
from ..models.submission import DocumentType
from .audit_service import log_action

DOCUMENT_TYPE_LABELS = {
    DocumentType.ID: "ID card",
    DocumentType.PASS: "Passport",
    DocumentType.BIRTH: "Birth certificate",
    DocumentType.LIC: "Driver’s licence",
    DocumentType.OTHER: "Student card"
}


def get_listings(
    db: Session,
    status_filter: Optional[str] = None,
    doc_type: Optional[str] = None,
    town: Optional[str] = None,
    query: Optional[str] = None,
    skip: int = 0,
    limit: int = 100
) -> List[Listing]:
    q = db.query(Listing)

    if status_filter and status_filter != "All":
        q = q.filter(Listing.status == status_filter)

    if doc_type and doc_type != "All":
        q = q.filter(Listing.document_type == doc_type)

    if town and town != "All towns":
        q = q.filter(Listing.town.ilike(f"%{town}%"))

    if query:
        term = f"%{query}%"
        q = q.filter(
            (Listing.town.ilike(term)) |
            (Listing.redacted_name.ilike(term)) |
            (Listing.spot_description.ilike(term))
        )

    return q.order_by(Listing.id.desc()).offset(skip).limit(limit).all()


def get_listing_by_id(db: Session, listing_id: int) -> Listing:
    listing = db.query(Listing).filter(Listing.id == listing_id).first()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")
    listing.views_count += 1
    db.commit()
    db.refresh(listing)
    return listing


def update_listing_status(
    db: Session,
    listing_id: int,
    new_status: ListingStatus,
    actor_name: str = "Admin Antony"
) -> Listing:
    listing = db.query(Listing).filter(Listing.id == listing_id).first()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")

    listing.status = new_status
    doc_label = DOCUMENT_TYPE_LABELS.get(listing.document_type, "Document")
    log_action(db, f"set listing {doc_label} · {listing.town} to {new_status.value}", actor_name)
    db.commit()
    db.refresh(listing)
    return listing
