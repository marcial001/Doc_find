from fastapi import APIRouter
from .auth import router as auth_router
from .submissions import router as submissions_router
from .listings import router as listings_router
from .claims import router as claims_router
from .alerts import router as alerts_router
from .admin import router as admin_router

api_v1_router = APIRouter()

api_v1_router.include_router(auth_router)
api_v1_router.include_router(submissions_router)
api_v1_router.include_router(listings_router)
api_v1_router.include_router(claims_router)
api_v1_router.include_router(alerts_router)
api_v1_router.include_router(admin_router)
