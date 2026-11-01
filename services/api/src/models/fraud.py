import enum
from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, DateTime, Enum
from ..core.database import Base


class FraudSeverity(str, enum.Enum):
    LOW = "Low"
    MEDIUM = "Medium"
    HIGH = "High"


class FraudStatus(str, enum.Enum):
    OPEN = "open"
    SUSPENDED = "Suspended"
    DISMISSED = "Dismissed"


class FraudReport(Base):
    __tablename__ = "fraud_reports"

    id = Column(Integer, primary_key=True, index=True)
    who = Column(String(128), nullable=False)
    why = Column(String(500), nullable=False)
    source_by = Column(String(64), default="Automatic rule", nullable=False)
    severity = Column(Enum(FraudSeverity), default=FraudSeverity.MEDIUM, nullable=False)
    status = Column(Enum(FraudStatus), default=FraudStatus.OPEN, nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)
