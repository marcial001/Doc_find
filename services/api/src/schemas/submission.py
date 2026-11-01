from datetime import datetime
from typing import Optional, Dict, Any
from pydantic import BaseModel, Field, ConfigDict
from ..models.submission import DocumentType, PhotoQuality, SubmissionStatus


class DocumentDataSchema(BaseModel):
    name: str = Field(..., description="Document holder name")
    num: str = Field(..., description="Document serial number")
    dob: str = Field(..., description="Date of birth")
    addr: str = Field(..., description="Address or town")


class RedactionSettingsSchema(BaseModel):
    name: bool = True
    num: bool = True
    dob: bool = True
    addr: bool = True
    photo: bool = True
    blur: int = 7


class SubmissionCreate(BaseModel):
    document_type: DocumentType
    town: str = Field(..., min_length=2)
    spot_description: str = Field(..., min_length=3)
    finder_name: str = Field(..., min_length=2)
    finder_phone: str = Field(..., min_length=9)

    # Law No. 2024/017 mandatory consents
    photo_consent: bool = Field(..., description="Consent to process photo")
    location_consent: bool = Field(..., description="Consent to process location")
    phone_consent: bool = Field(False, description="Consent for phone contact during handoff")

    photo_quality: PhotoQuality = PhotoQuality.SHARP
    data: DocumentDataSchema
    redactions: Optional[RedactionSettingsSchema] = None


class SubmissionReview(BaseModel):
    action: str = Field(..., description="'approve', 'retake', or 'reject'")
    reason: Optional[str] = None


class SubmissionResponse(BaseModel):
    id: int
    finder_id: Optional[int]
    document_type: DocumentType
    town: str
    spot_description: str
    finder_name: str
    finder_phone: str
    photo_consent: bool
    location_consent: bool
    phone_consent: bool
    photo_quality: PhotoQuality
    status: SubmissionStatus
    reject_reason: Optional[str]
    data_json: Dict[str, Any]
    redaction_json: Dict[str, Any]
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
