from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr, Field, ConfigDict
from ..models.user import UserRole


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenPayload(BaseModel):
    sub: Optional[str] = None


class LoginRequest(BaseModel):
    email_or_phone: str = Field(..., description="Email or phone number")
    password: str = Field(..., min_length=6)


class RegisterRequest(BaseModel):
    full_name: str = Field(..., min_length=2)
    email: EmailStr
    phone: str = Field(..., description="Cameroon phone number")
    password: str = Field(..., min_length=6)
    consent: bool = Field(..., description="Strict opt-in consent for Law No. 2024/017")


class UserResponse(BaseModel):
    id: int
    email: EmailStr
    phone: str
    full_name: str
    role: UserRole
    is_active: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
