from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field, ConfigDict
from ..models.submission import DocumentType
from ..models.listing import ListingStatus


class ListingResponse(BaseModel):
    id: int
    submission_id: Optional[int]
    document_type: DocumentType
    town: str
    spot_description: str
    redacted_name: str
    status: ListingStatus
    views_count: int
    claims_count: int
    days_online: int
    secret_question: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class ListingUpdateStatus(BaseModel):
    status: ListingStatus = Field(..., description="'Live', 'Recovered', or 'Archived'")
