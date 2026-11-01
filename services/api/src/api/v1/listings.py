from typing import List, Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from ...core.database import get_db
from ...schemas.listing import ListingResponse
from ...services.listing_service import get_listings, get_listing_by_id

router = APIRouter(prefix="/listings", tags=["Listings"])


@router.get("/", response_model=List[ListingResponse])
def list_documents(
    status: Optional[str] = Query(None, description="'Live', 'Recovered', 'Archived'"),
    doc_type: Optional[str] = Query(None, description="Document type filter"),
    town: Optional[str] = Query(None, description="Town filter"),
    q: Optional[str] = Query(None, description="Search term"),
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db)
):
    return get_listings(
        db,
        status_filter=status,
        doc_type=doc_type,
        town=town,
        query=q,
        skip=skip,
        limit=limit
    )


@router.get("/{id}", response_model=ListingResponse)
def get_listing_detail(id: int, db: Session = Depends(get_db)):
    return get_listing_by_id(db, id)
