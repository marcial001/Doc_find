from src.models.listing import Listing, ListingStatus
from src.models.submission import DocumentType


def test_list_and_filter_listings(client, db_session):
    l1 = Listing(
        document_type=DocumentType.ID,
        town="Douala",
        spot_description="Akwa",
        redacted_name="K•••• N••••",
        status=ListingStatus.LIVE,
        secret_question="Which town issued your card?",
        expected_answer="Douala"
    )
    l2 = Listing(
        document_type=DocumentType.PASS,
        town="Yaoundé",
        spot_description="Mvan",
        redacted_name="M•••• T••••",
        status=ListingStatus.LIVE,
        secret_question="What is your date of birth?",
        expected_answer="04 Aug 1991"
    )
    db_session.add_all([l1, l2])
    db_session.commit()

    # List all
    resp = client.get("/api/v1/listings/")
    assert resp.status_code == 200
    assert len(resp.json()) >= 2

    # Filter by town
    resp_douala = client.get("/api/v1/listings/?town=Douala")
    assert resp_douala.status_code == 200
    for item in resp_douala.json():
        assert "Douala" in item["town"]

    # Filter by document type
    resp_pass = client.get("/api/v1/listings/?doc_type=pass")
    assert resp_pass.status_code == 200
    for item in resp_pass.json():
        assert item["document_type"] == "pass"


def test_get_listing_detail_increments_views(client, db_session):
    l = Listing(
        document_type=DocumentType.BIRTH,
        town="Bafoussam",
        spot_description="Marché A",
        redacted_name="E•••• A••••",
        status=ListingStatus.LIVE,
        secret_question="What is your mother's first name?",
        expected_answer="Rosine",
        views_count=5
    )
    db_session.add(l)
    db_session.commit()

    resp = client.get(f"/api/v1/listings/{l.id}")
    assert resp.status_code == 200
    assert resp.json()["views_count"] == 6
