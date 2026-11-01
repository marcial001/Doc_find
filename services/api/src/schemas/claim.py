from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field, ConfigDict
from ..models.claim import ClaimStatus, ClaimRisk


class ClaimMessageCreate(BaseModel):
    text: str = Field(..., min_length=1, max_length=1000)


class ClaimMessageResponse(BaseModel):
    id: int
    claim_id: int
    sender_type: str
    text: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class ClaimCreate(BaseModel):
    listing_id: int
    submitted_answer: str = Field(..., min_length=1)
    claimant_name: str = Field(..., min_length=2)
    claimant_phone: str = Field(..., min_length=9)
    has_id_photo: bool = False


class ClaimHandoffRequest(BaseModel):
    pickup_point: str = Field(..., min_length=3)
    handoff_time: str = Field(..., min_length=3)


class ClaimResponse(BaseModel):
    id: int
    listing_id: int
    claimant_id: Optional[int]
    claimant_name: str
    claimant_phone: str
    submitted_answer: str
    is_matched: bool
    has_id_photo: bool
    risk_level: ClaimRisk
    risk_signals: List[str]
    status: ClaimStatus
    handoff_location: Optional[str]
    handoff_time: Optional[str]
    created_at: datetime
    messages: List[ClaimMessageResponse] = []

    model_config = ConfigDict(from_attributes=True)
