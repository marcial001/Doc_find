import pytest
from typing import Generator
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.pool import StaticPool

from src.core.database import Base, get_db
from src.main import app
from src.models.user import User, UserRole
from src.core.security import get_password_hash

# In-memory SQLite test database
SQLALCHEMY_DATABASE_URL = "sqlite:///:memory:"

test_engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=test_engine)


@pytest.fixture(scope="function")
def db_session() -> Generator[Session, None, None]:
    Base.metadata.create_all(bind=test_engine)
    session = TestingSessionLocal()

    # Seed demo and admin users
    demo_user = User(
        email="demo@docfind.cm",
        phone="+237 670 000 000",
        full_name="Kevin Nkeng",
        hashed_password=get_password_hash("demo1234"),
        role=UserRole.USER,
        is_active=True
    )
    admin_user = User(
        email="admin@docfind.cm",
        phone="+237 690 000 000",
        full_name="Antony",
        hashed_password=get_password_hash("admin1234"),
        role=UserRole.ADMIN,
        is_active=True
    )
    session.add_all([demo_user, admin_user])
    session.commit()

    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(bind=test_engine)


@pytest.fixture(scope="function")
def client(db_session: Session) -> Generator[TestClient, None, None]:
    def override_get_db():
        try:
            yield db_session
        finally:
            pass

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()
