from typing import List, Optional
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from ...core.database import get_db
from ...schemas.claim import ClaimCreate, ClaimResponse, ClaimMessageCreate, ClaimMessageResponse
from ...services.claim_service import create_claim, send_claim_message
from ..deps import get_current_user
from ...models.user import User
from ...models.claim import Claim

router = APIRouter(prefix="/claims", tags=["Claims"])


@router.post("/", response_model=ClaimResponse, status_code=status.HTTP_201_CREATED)
def submit_claim(
    data: ClaimCreate,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user)
):
    claimant_id = current_user.id if current_user else None
    return create_claim(db, data, claimant_id=claimant_id)


@router.get("/mine", response_model=List[ClaimResponse])
def get_my_claims(
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user)
):
    if not current_user:
        return []
    return db.query(Claim).filter(Claim.claimant_id == current_user.id).all()


@router.post("/{id}/messages", response_model=ClaimMessageResponse)
def post_message(
    id: int,
    data: ClaimMessageCreate,
    db: Session = Depends(get_db)
):
    return send_claim_message(db, claim_id=id, sender_type="u", text=data.text)
