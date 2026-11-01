from typing import Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from ..models.user import User, UserRole
from ..schemas.auth import RegisterRequest
from ..core.security import get_password_hash, verify_password


def get_user_by_email_or_phone(db: Session, identifier: str) -> Optional[User]:
    return (
        db.query(User)
        .filter((User.email == identifier) | (User.phone == identifier))
        .first()
    )


def authenticate_user(db: Session, email_or_phone: str, password: str) -> Optional[User]:
    user = get_user_by_email_or_phone(db, email_or_phone)
    if not user:
        return None
    if not verify_password(password, user.hashed_password):
        return None
    return user


def register_user(db: Session, data: RegisterRequest) -> User:
    if not data.consent:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Law No. 2024/017 consent is required to create an account."
        )

    existing_email = db.query(User).filter(User.email == data.email).first()
    if existing_email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="An account with this email already exists."
        )

    existing_phone = db.query(User).filter(User.phone == data.phone).first()
    if existing_phone:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="An account with this phone number already exists."
        )

    hashed_pw = get_password_hash(data.password)
    user = User(
        email=data.email,
        phone=data.phone,
        full_name=data.full_name,
        hashed_password=hashed_pw,
        role=UserRole.USER,
        is_active=True
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user
