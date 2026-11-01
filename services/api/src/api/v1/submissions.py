from typing import List, Optional
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from ...core.database import get_db
from ...schemas.submission import SubmissionCreate, SubmissionResponse
from ...services.submission_service import create_submission
from ..deps import get_current_user
from ...models.user import User
from ...models.submission import DocumentSubmission

router = APIRouter(prefix="/submissions", tags=["Submissions"])


@router.post("/", response_model=SubmissionResponse, status_code=status.HTTP_201_CREATED)
def submit_found_document(
    data: SubmissionCreate,
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user)
):
    finder_id = current_user.id if current_user else None
    return create_submission(db, data, finder_id=finder_id)


@router.get("/mine", response_model=List[SubmissionResponse])
def get_my_submissions(
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user)
):
    if not current_user:
        return []
    return db.query(DocumentSubmission).filter(DocumentSubmission.finder_id == current_user.id).all()
