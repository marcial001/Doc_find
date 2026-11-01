from src.models.listing import Listing, ListingStatus
from src.models.submission import DocumentType
from src.models.claim import ClaimRisk, ClaimStatus


def test_create_claim_and_message(client, db_session):
    l = Listing(
        document_type=DocumentType.ID,
        town="Douala",
        spot_description="Akwa",
        redacted_name="K•••• N••••",
        status=ListingStatus.LIVE,
        secret_question="Which town issued your card?",
        expected_answer="Douala"
    )
    db_session.add(l)
    db_session.commit()

    # Create claim with matching answer
    claim_payload = {
        "listing_id": l.id,
        "submitted_answer": "Douala",
        "claimant_name": "Kevin Nkeng",
        "claimant_phone": "+237 677 981 022",
        "has_id_photo": True
    }
    resp = client.post("/api/v1/claims/", json=claim_payload)
    assert resp.status_code == 201
    claim_data = resp.json()
    assert claim_data["is_matched"] is True
    assert claim_data["risk_level"] == "Low"
    assert claim_data["status"] == "new"

    # Send message to claimant thread
    claim_id = claim_data["id"]
    msg_payload = {"text": "I can pick it up tomorrow."}
    msg_resp = client.post(f"/api/v1/claims/{claim_id}/messages", json=msg_payload)
    assert msg_resp.status_code == 200
    assert msg_resp.json()["text"] == "I can pick it up tomorrow."
