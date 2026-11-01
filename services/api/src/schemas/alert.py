from datetime import datetime
from typing import Optional
from pydantic import BaseModel, ConfigDict
from ..models.submission import DocumentType


class AlertCreate(BaseModel):
    document_type: Optional[DocumentType] = None
    town: Optional[str] = None


class AlertResponse(BaseModel):
    id: int
    user_id: int
    document_type: Optional[DocumentType]
    town: Optional[str]
    is_active: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
