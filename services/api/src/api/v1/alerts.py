from typing import List, Optional
from fastapi import APIRouter, Depends, status, HTTPException
from sqlalchemy.orm import Session
from ...core.database import get_db
from ...schemas.alert import AlertCreate, AlertResponse
from ..deps import require_current_user
from ...models.user import User
from ...models.alert import SearchAlert

router = APIRouter(prefix="/alerts", tags=["Search Alerts"])


@router.post("/", response_model=AlertResponse, status_code=status.HTTP_201_CREATED)
def create_alert(
    data: AlertCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_current_user)
):
    alert = SearchAlert(
        user_id=current_user.id,
        document_type=data.document_type,
        town=data.town,
        is_active=True
    )
    db.add(alert)
    db.commit()
    db.refresh(alert)
    return alert


@router.get("/", response_model=List[AlertResponse])
def get_alerts(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_current_user)
):
    return db.query(SearchAlert).filter(SearchAlert.user_id == current_user.id).all()


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_alert(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_current_user)
):
    alert = db.query(SearchAlert).filter(
        SearchAlert.id == id,
        SearchAlert.user_id == current_user.id
    ).first()
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")

    db.delete(alert)
    db.commit()
    return None
