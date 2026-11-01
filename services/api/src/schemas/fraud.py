from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict
from ..models.fraud import FraudSeverity, FraudStatus


class FraudReportCreate(BaseModel):
    who: str = Field(..., min_length=2)
    why: str = Field(..., min_length=5)
    source_by: str = "Admin flag"
    severity: FraudSeverity = FraudSeverity.MEDIUM


class FraudReportResponse(BaseModel):
    id: int
    who: str
    why: str
    source_by: str
    severity: FraudSeverity
    status: FraudStatus
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
