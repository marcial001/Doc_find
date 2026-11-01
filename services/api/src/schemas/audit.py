from datetime import datetime
from pydantic import BaseModel, ConfigDict


class AuditLogResponse(BaseModel):
    id: int
    actor_name: str
    action: str
    is_sensitive: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
