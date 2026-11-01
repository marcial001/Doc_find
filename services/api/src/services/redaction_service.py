from typing import Tuple, List
from ..models.submission import DocumentType
from ..models.claim import ClaimRisk


def mask_name(name: str) -> str:
    if not name:
        return ""
    words = name.strip().split()
    masked_words = []
    for w in words:
        if not w:
            continue
        mask_len = max(3, len(w) - 1)
        masked_words.append(w[0] + ("•" * mask_len))
    return " ".join(masked_words)


def get_default_secret_question(doc_type: DocumentType) -> str:
    if doc_type == DocumentType.ID:
        return "Which town issued your card?"
    elif doc_type == DocumentType.PASS:
        return "What is your date of birth?"
    elif doc_type == DocumentType.BIRTH:
        return "What is your mother’s first name?"
    elif doc_type == DocumentType.LIC:
        return "Which date is printed as the issue date?"
    else:
        return "Which date is printed as the issue date?"


def evaluate_proof_answer(
    expected_answer: str,
    submitted_answer: str,
    claimant_name: str,
    doc_holder_name: str,
    has_id_photo: bool
) -> Tuple[bool, ClaimRisk, List[str]]:
    expected_norm = expected_answer.strip().lower()
    submitted_norm = submitted_answer.strip().lower()

    is_matched = (expected_norm == submitted_norm)
    signals = []

    # Check name match
    name_matched = (
        claimant_name.strip().lower() in doc_holder_name.strip().lower() or
        doc_holder_name.strip().lower() in claimant_name.strip().lower()
    )

    if name_matched:
        signals.append("Name matches document")
    else:
        signals.append("Claimant name differs from document")

    if is_matched:
        signals.append("Answer matches")
    else:
        signals.append("Answer is close but wrong")

    if has_id_photo:
        signals.append("ID photo attached")
    else:
        signals.append("No ID photo attached")

    # Assess Risk
    if is_matched and has_id_photo:
        risk = ClaimRisk.LOW
    elif is_matched and not has_id_photo:
        risk = ClaimRisk.MEDIUM
    else:
        risk = ClaimRisk.HIGH

    return is_matched, risk, signals
