from src.services.redaction_service import (
    mask_name,
    mask_document_number,
    is_cameroon_id_valid,
    detect_sensitive_entities,
    suggest_document_redaction_boxes,
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


def test_mask_document_number():
    assert mask_document_number("117392819") == "11•••••19"
    assert mask_document_number("1098273641") == "10••••••41"
    assert mask_document_number("AA1234567") == "AA•••••67"
    assert mask_document_number("123") == "1••"
    assert mask_document_number("") == ""


def test_is_cameroon_id_valid():
    assert is_cameroon_id_valid("117392819") is True
    assert is_cameroon_id_valid("1098273641") is True
    assert is_cameroon_id_valid("117 392 819") is True
    assert is_cameroon_id_valid("117-392-819") is True
    # Invalid length or non-digits
    assert is_cameroon_id_valid("12345") is False
    assert is_cameroon_id_valid("123456789012") is False
    assert is_cameroon_id_valid("11739281A") is False
    assert is_cameroon_id_valid("") is False


def test_detect_sensitive_entities():
    sample_text = (
        "REPUBLIQUE DU CAMEROUN\n"
        "CARTE NATIONALE D'IDENTITE / NATIONAL IDENTITY CARD\n"
        "Numero CNI: 117392819\n"
        "Date de naissance: 14/08/1995 à Douala\n"
        "Contact: +237 670123456\n"
        "Passeport precedent: AA7654321"
    )
    entities = detect_sensitive_entities(sample_text)
    types_found = [e["type"] for e in entities]
    
    assert "cni_number" in types_found
    assert "date" in types_found
    assert "issuing_town" in types_found
    assert "phone" in types_found
    assert "passport_number" in types_found
    
    cni_entity = next(e for e in entities if e["type"] == "cni_number")
    assert cni_entity["value"] == "117392819"

    town_entity = next(e for e in entities if e["type"] == "issuing_town")
    assert town_entity["value"] == "Douala"

    # Empty text case
    assert detect_sensitive_entities("") == []


def test_suggest_document_redaction_boxes():
    id_boxes = suggest_document_redaction_boxes(DocumentType.ID)
    assert len(id_boxes) >= 2
    fields = [b["field"] for b in id_boxes]
    assert "cni_number" in fields
    assert "dob" in fields
    assert all("box" in b and "x" in b["box"] for b in id_boxes)

    pass_boxes = suggest_document_redaction_boxes(DocumentType.PASS)
    assert len(pass_boxes) >= 2
    pass_fields = [b["field"] for b in pass_boxes]
    assert "passport_number" in pass_fields

    # Filtered fields
    filtered = suggest_document_redaction_boxes(DocumentType.ID, fields_to_redact=["cni_number"])
    assert len(filtered) == 1
    assert filtered[0]["field"] == "cni_number"

    # Default fallback
    birth_boxes = suggest_document_redaction_boxes(DocumentType.BIRTH)
    assert len(birth_boxes) >= 1


def test_get_default_secret_question():
    assert get_default_secret_question(DocumentType.ID) == "Which town issued your card?"
    assert get_default_secret_question(DocumentType.PASS) == "What is your date of birth?"
    assert get_default_secret_question(DocumentType.BIRTH) == "What is your mother’s first name?"
    assert get_default_secret_question(DocumentType.LIC) == "Which date is printed as the issue date?"
    assert get_default_secret_question(DocumentType.OTHER) == "Which date is printed as the issue date?"


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


def test_evaluate_proof_answer_matched_no_photo():
    is_matched, risk, signals = evaluate_proof_answer(
        expected_answer="Douala",
        submitted_answer="Douala",
        claimant_name="Kevin Nkeng",
        doc_holder_name="Kevin Nkeng",
        has_id_photo=False
    )
    assert is_matched is True
    assert risk == ClaimRisk.MEDIUM
    assert "No ID photo attached" in signals


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
