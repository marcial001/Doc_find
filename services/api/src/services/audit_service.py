from sqlalchemy.orm import Session
from ..models.audit import AuditLog


def log_action(
    db: Session,
    action: str,
    actor_name: str = "Admin Antony",
    is_sensitive: bool = False
) -> AuditLog:
    entry = AuditLog(
        actor_name=actor_name,
        action=action,
        is_sensitive=is_sensitive
    )
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return entry
