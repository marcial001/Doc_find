import enum
from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, DateTime, Enum, ForeignKey
from sqlalchemy.orm import relationship
from ..core.database import Base
from .submission import DocumentType


class ListingStatus(str, enum.Enum):
    LIVE = "Live"
    RECOVERED = "Recovered"
    ARCHIVED = "Archived"


class Listing(Base):
    __tablename__ = "listings"

    id = Column(Integer, primary_key=True, index=True)
    submission_id = Column(Integer, ForeignKey("document_submissions.id"), nullable=True)
    document_type = Column(Enum(DocumentType), nullable=False)
    town = Column(String(64), nullable=False, index=True)
    spot_description = Column(String(255), nullable=False)

    # Public Redacted Info
    redacted_name = Column(String(128), nullable=False)

    status = Column(Enum(ListingStatus), default=ListingStatus.LIVE, nullable=False, index=True)
    views_count = Column(Integer, default=0, nullable=False)
    claims_count = Column(Integer, default=0, nullable=False)
    days_online = Column(Integer, default=0, nullable=False)

    # Verification Question and Expected Answer
    secret_question = Column(String(255), nullable=False)
    expected_answer = Column(String(255), nullable=False)

    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)

    submission = relationship("DocumentSubmission", back_populates="listing")
    claims = relationship("Claim", back_populates="listing")
