import enum
from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Enum, ForeignKey, JSON
from sqlalchemy.orm import relationship
from ..core.database import Base


class ClaimStatus(str, enum.Enum):
    NEW = "new"
    MORE = "more"
    HANDOFF = "handoff"
    DONE = "done"
    REJECTED = "rejected"


class ClaimRisk(str, enum.Enum):
    LOW = "Low"
    MEDIUM = "Medium"
    HIGH = "High"


class Claim(Base):
    __tablename__ = "claims"

    id = Column(Integer, primary_key=True, index=True)
    listing_id = Column(Integer, ForeignKey("listings.id"), nullable=False)
    claimant_id = Column(Integer, ForeignKey("users.id"), nullable=True)

    claimant_name = Column(String(128), nullable=False)
    claimant_phone = Column(String(32), nullable=False)
    submitted_answer = Column(String(255), nullable=False)
    is_matched = Column(Boolean, default=False, nullable=False)
    has_id_photo = Column(Boolean, default=False, nullable=False)

    risk_level = Column(Enum(ClaimRisk), default=ClaimRisk.LOW, nullable=False)
    risk_signals = Column(JSON, default=list, nullable=False)
    status = Column(Enum(ClaimStatus), default=ClaimStatus.NEW, nullable=False)

    handoff_location = Column(String(255), nullable=True)
    handoff_time = Column(String(64), nullable=True)

    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)

    listing = relationship("Listing", back_populates="claims")
    claimant = relationship("User", back_populates="claims")
    messages = relationship("ClaimMessage", back_populates="claim", cascade="all, delete-orphan")


class ClaimMessage(Base):
    __tablename__ = "claim_messages"

    id = Column(Integer, primary_key=True, index=True)
    claim_id = Column(Integer, ForeignKey("claims.id"), nullable=False)
    sender_type = Column(String(8), nullable=False)  # 'u' for user/claimant, 'a' for admin
    text = Column(String(1000), nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)

    claim = relationship("Claim", back_populates="messages")
