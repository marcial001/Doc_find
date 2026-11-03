import re
from typing import Tuple, List, Dict, Any, Optional
from ..models.submission import DocumentType
from ..models.claim import ClaimRisk

# Common major Cameroonian towns & administrative centers
CAMEROON_TOWNS = [
    "Douala", "Yaoundé", "Yaounde", "Bafoussam", "Bamenda", "Garoua",
    "Maroua", "Ngaoundéré", "Ngaoundere", "Bertoua", "Ebolowa", "Buea",
    "Kribi", "Limbe", "Limbé", "Dschang", "Kumba", "Nkongsamba", "Foumban",
    "Edéa", "Edea", "Bafia", "Mbalmayo", "Tiko", "Meiganga", "Mbouda"
]

# Sensitive patterns for Cameroonian documents (CNI, Passport, Phone, Dates)
CAMEROON_CNI_REGEX = re.compile(r"\b\d{9,10}\b")
CAMEROON_PASSPORT_REGEX = re.compile(r"\b[A-Z]{1,2}\d{7,8}\b")
CAMEROON_PHONE_REGEX = re.compile(r"(?:\+237|237)?\s*[62]\d{2}[\s.-]?\d{3}[\s.-]?\d{3}\b")
DATE_PATTERN_REGEX = re.compile(
    r"\b(?:\d{1,2}[./-]\d{1,2}[./-]\d{2,4}|\d{1,2}\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\.?\s+\d{4})\b",
    re.IGNORECASE
)


def mask_name(name: str) -> str:
    """
    Mask a personal name according to Law 2024/017 privacy requirements.
    Retains only the first letter of each word and masks remaining letters.
    """
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


def mask_document_number(doc_num: str) -> str:
    """
    Mask document number (CNI or Passport) keeping only the first 2 and last 2 characters.
    """
    if not doc_num:
        return ""
    cleaned = doc_num.strip()
    if len(cleaned) <= 4:
        return cleaned[0] + ("•" * max(1, len(cleaned) - 1))
    
    middle_mask = "•" * (len(cleaned) - 4)
    return f"{cleaned[:2]}{middle_mask}{cleaned[-2:]}"


def is_cameroon_id_valid(cni_number: str) -> bool:
    """
    Validates if a given string matches Cameroon National Identity Number (CNI) format.
    Cameroon CNI numbers consist of 9 or 10 digits.
    """
    if not cni_number:
        return False
    cleaned = cni_number.strip().replace(" ", "").replace("-", "")
    return bool(re.fullmatch(r"\d{9,10}", cleaned))


def detect_sensitive_entities(text: str) -> List[Dict[str, Any]]:
    """
    Scans extracted OCR or document text to detect sensitive PII entities
    subject to Cameroon Law No. 2024/017 (CNI, Dates of Birth/Issue, Town of Issue, Phone).
    """
    if not text:
        return []
    
    entities: List[Dict[str, Any]] = []

    # 1. Detect Cameroon CNI
    for match in CAMEROON_CNI_REGEX.finditer(text):
        entities.append({
            "type": "cni_number",
            "value": match.group(0),
            "start": match.start(),
            "end": match.end(),
            "confidence": 0.95
        })

    # 2. Detect Cameroon Passport Numbers
    for match in CAMEROON_PASSPORT_REGEX.finditer(text):
        entities.append({
            "type": "passport_number",
            "value": match.group(0),
            "start": match.start(),
            "end": match.end(),
            "confidence": 0.90
        })

    # 3. Detect Dates (Birth, Issue, Expiry)
    for match in DATE_PATTERN_REGEX.finditer(text):
        entities.append({
            "type": "date",
            "value": match.group(0),
            "start": match.start(),
            "end": match.end(),
            "confidence": 0.88
        })

    # 4. Detect Cameroon Phone Numbers
    for match in CAMEROON_PHONE_REGEX.finditer(text):
        entities.append({
            "type": "phone",
            "value": match.group(0),
            "start": match.start(),
            "end": match.end(),
            "confidence": 0.92
        })

    # 5. Detect Known Cameroon Towns
    for town in CAMEROON_TOWNS:
        pattern = re.compile(rf"\b{re.escape(town)}\b", re.IGNORECASE)
        for match in pattern.finditer(text):
            entities.append({
                "type": "issuing_town",
                "value": match.group(0),
                "start": match.start(),
                "end": match.end(),
                "confidence": 0.85
            })

    return entities


def suggest_document_redaction_boxes(
    doc_type: DocumentType,
    fields_to_redact: Optional[List[str]] = None
) -> List[Dict[str, Any]]:
    """
    Generates suggested normalized bounding boxes [x, y, width, height] (0.0 to 1.0)
    for Cameroon official document templates under Law No. 2024/017.
    """
    suggestions = []
    
    if doc_type == DocumentType.ID:
        # Standard Cameroon National Identity Card template
        default_boxes = [
            {
                "field": "cni_number",
                "label": "CNI Identification Number",
                "box": {"x": 0.55, "y": 0.15, "width": 0.40, "height": 0.08},
                "reason": "Law 2024/017: Unique National Identifier"
            },
            {
                "field": "dob",
                "label": "Date and Place of Birth",
                "box": {"x": 0.35, "y": 0.42, "width": 0.60, "height": 0.10},
                "reason": "Law 2024/017: Birth & Origin PII"
            },
            {
                "field": "authority_signature",
                "label": "Issuing Authority & Delegation",
                "box": {"x": 0.50, "y": 0.75, "width": 0.45, "height": 0.18},
                "reason": "Law 2024/017: Official Seal & Security Signature"
            }
        ]
    elif doc_type == DocumentType.PASS:
        # Standard CEMAC / Cameroon Passport Bio-Data page
        default_boxes = [
            {
                "field": "passport_number",
                "label": "Passport Number",
                "box": {"x": 0.70, "y": 0.08, "width": 0.25, "height": 0.06},
                "reason": "Law 2024/017: Travel Document Identifier"
            },
            {
                "field": "mrz_zone",
                "label": "Machine Readable Zone (MRZ)",
                "box": {"x": 0.05, "y": 0.82, "width": 0.90, "height": 0.15},
                "reason": "Law 2024/017: Unencrypted MRZ Optical Code"
            }
        ]
    else:
        # Generic document layout
        default_boxes = [
            {
                "field": "sensitive_number",
                "label": "Document Serial Number",
                "box": {"x": 0.40, "y": 0.10, "width": 0.55, "height": 0.10},
                "reason": "Law 2024/017: Unique Document Identifier"
            }
        ]

    if fields_to_redact:
        filtered = [b for b in default_boxes if b["field"] in fields_to_redact]
        return filtered if filtered else default_boxes
    
    return default_boxes


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
