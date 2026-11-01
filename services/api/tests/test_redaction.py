from src.services.redaction_service import (
    mask_name,
    get_default_secret_question,
    evaluate_proof_answer
)
from src.models.submission import DocumentType
from src.models.claim import ClaimRisk


def test_mask_name():
    assert mask_name("Kevin Nkeng") == "K•••• N••••"
    assert mask_name("Marie") == "M••••"
    assert mask_name("A B") == "A••• B•••"
    assert mask_name("") == ""


def test_get_default_secret_question():
    assert get_default_secret_question(DocumentType.ID) == "Which town issued your card?"
    assert get_default_secret_question(DocumentType.PASS) == "What is your date of birth?"
    assert get_default_secret_question(DocumentType.BIRTH) == "What is your mother’s first name?"
    assert get_default_secret_question(DocumentType.LIC) == "Which date is printed as the issue date?"


def test_evaluate_proof_answer_matched():
    is_matched, risk, signals = evaluate_proof_answer(
        expected_answer="Douala",
        submitted_answer="douala",
        claimant_name="Kevin Nkeng",
        doc_holder_name="Kevin Nkeng",
        has_id_photo=True
    )
    assert is_matched is True
    assert risk == ClaimRisk.LOW
    assert "Answer matches" in signals
    assert "ID photo attached" in signals


def test_evaluate_proof_answer_mismatched():
    is_matched, risk, signals = evaluate_proof_answer(
        expected_answer="04 Aug 1991",
        submitted_answer="14 Aug 1991",
        claimant_name="Marie Tchoua",
        doc_holder_name="Marie Tchoua",
        has_id_photo=False
    )
    assert is_matched is False
    assert risk == ClaimRisk.HIGH
    assert "Answer is close but wrong" in signals
    assert "No ID photo attached" in signals
