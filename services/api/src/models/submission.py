import enum
from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Enum, ForeignKey, Text, JSON
from sqlalchemy.orm import relationship
from ..core.database import Base


class DocumentType(str, enum.Enum):
    ID = "id"
    PASS = "pass"
    BIRTH = "birth"
    LIC = "lic"
    OTHER = "other"


class PhotoQuality(str, enum.Enum):
    SHARP = "Sharp"
    BLURRY = "Slightly blurry"
    TOO_DARK = "Too dark: retake advised"


class SubmissionStatus(str, enum.Enum):
    PENDING_REVIEW = "pending_review"
    APPROVED = "approved"
    REJECTED = "rejected"
    ARCHIVED = "archived"


class DocumentSubmission(Base):
    __tablename__ = "document_submissions"

    id = Column(Integer, primary_key=True, index=True)
    finder_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    document_type = Column(Enum(DocumentType), nullable=False)
    town = Column(String(64), nullable=False, index=True)
    spot_description = Column(String(255), nullable=False)
    finder_name = Column(String(128), nullable=False)
    finder_phone = Column(String(32), nullable=False)

    # Law No. 2024/017 consents
    photo_consent = Column(Boolean, default=False, nullable=False)
    location_consent = Column(Boolean, default=False, nullable=False)
    phone_consent = Column(Boolean, default=False, nullable=False)

    photo_quality = Column(Enum(PhotoQuality), default=PhotoQuality.SHARP, nullable=False)
    status = Column(Enum(SubmissionStatus), default=SubmissionStatus.PENDING_REVIEW, nullable=False)
    reject_reason = Column(String(255), nullable=True)

    # Document data dictionary: {"name": "...", "num": "...", "dob": "...", "addr": "..."}
    data_json = Column(JSON, nullable=False, default=dict)
    # Redaction configuration: {"name": bool, "num": bool, "dob": bool, "addr": bool, "photo": bool, "blur": int}
    redaction_json = Column(JSON, nullable=False, default=dict)

    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)

    finder = relationship("User", back_populates="submissions")
    listing = relationship("Listing", back_populates="submission", uselist=False)
