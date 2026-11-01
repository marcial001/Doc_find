from src.models.submission import DocumentSubmission, DocumentType, PhotoQuality, SubmissionStatus
from src.models.listing import Listing, ListingStatus
from src.models.claim import Claim, ClaimStatus, ClaimRisk
from src.models.fraud import FraudReport, FraudStatus, FraudSeverity


def test_admin_overview_kpis(client):
    resp = client.get("/api/v1/admin/overview")
    assert resp.status_code == 200
    data = resp.json()
    assert "kpis" in data
    assert "weekly_chart" in data
    assert "recent_activity" in data


def test_admin_review_queue_and_reveal_audit(client, db_session):
    sub = DocumentSubmission(
        document_type=DocumentType.ID,
        town="Douala",
        spot_description="Akwa",
        finder_name="Paul Mbarga",
        finder_phone="677 12 04 55",
        photo_consent=True,
        location_consent=True,
        phone_consent=True,
        photo_quality=PhotoQuality.SHARP,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json={"name": "Kevin Nkeng", "num": "1020 4457 8812", "dob": "12 Mar 1996", "addr": "Bonanjo"}
    )
    db_session.add(sub)
    db_session.commit()

    # List queue
    resp = client.get("/api/v1/admin/submissions")
    assert resp.status_code == 200
    assert len(resp.json()) >= 1

    # Reveal original photo (must log sensitive audit entry under Cameroon Law 2024/017)
    rev_resp = client.post(f"/api/v1/admin/submissions/{sub.id}/reveal")
    assert rev_resp.status_code == 200

    audit_resp = client.get("/api/v1/admin/audit?sensitive_only=true")
    assert audit_resp.status_code == 200
    assert any("revealed an original document" in a["action"] for a in audit_resp.json())


def test_admin_approve_submission(client, db_session):
    sub = DocumentSubmission(
        document_type=DocumentType.PASS,
        town="Yaoundé",
        spot_description="Mvan",
        finder_name="Sandrine Ewane",
        finder_phone="690 55 21 08",
        photo_consent=True,
        location_consent=True,
        phone_consent=True,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json={"name": "Marie Tchoua", "num": "CE 0481 2290", "dob": "04 Aug 1991", "addr": "Bastos"}
    )
    db_session.add(sub)
    db_session.commit()

    resp = client.post(
        f"/api/v1/admin/submissions/{sub.id}/review",
        json={"action": "approve"}
    )
    assert resp.status_code == 200
    assert resp.json()["action"] == "approved"

    # Verify listing was created in DB
    listing = db_session.query(Listing).filter(Listing.submission_id == sub.id).first()
    assert listing is not None
    assert listing.status == ListingStatus.LIVE


def test_admin_reject_and_retake_submission(client, db_session):
    sub = DocumentSubmission(
        document_type=DocumentType.LIC,
        town="Douala",
        spot_description="Bonaberi",
        finder_name="Ines",
        finder_phone="699 04 76 62",
        photo_consent=True,
        location_consent=True,
        phone_consent=False,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json={"name": "Felix Bella", "num": "PC 77 301 884", "dob": "30 Sep 1988", "addr": "Bonaberi"}
    )
    db_session.add(sub)
    db_session.commit()

    # Retake
    retake_resp = client.post(
        f"/api/v1/admin/submissions/{sub.id}/review",
        json={"action": "retake"}
    )
    assert retake_resp.status_code == 200
    assert retake_resp.json()["action"] == "retake_requested"

    # Reject
    rej_resp = client.post(
        f"/api/v1/admin/submissions/{sub.id}/review",
        json={"action": "reject", "reason": "Not an official document"}
    )
    assert rej_resp.status_code == 200
    assert rej_resp.json()["action"] == "rejected"


def test_admin_bulk_import(client):
    resp = client.post("/api/v1/admin/submissions/bulk?partner=Prefecture+of+Wouri")
    assert resp.status_code == 200
    assert "imported from Prefecture of Wouri" in resp.json()["message"]


def test_admin_claims_workflow(client, db_session):
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

    claim = Claim(
        listing_id=l.id,
        claimant_name="Kevin Nkeng",
        claimant_phone="677 98 10 22",
        submitted_answer="Douala",
        is_matched=True,
        has_id_photo=True,
        risk_level=ClaimRisk.LOW,
        status=ClaimStatus.NEW
    )
    db_session.add(claim)
    db_session.commit()

    # Get claims list
    c_list = client.get("/api/v1/admin/claims")
    assert c_list.status_code == 200
    assert len(c_list.json()) >= 1

    # Request more proof
    more_resp = client.post(f"/api/v1/admin/claims/{claim.id}/more-proof")
    assert more_resp.status_code == 200
    assert more_resp.json()["status"] == "more"

    # Schedule handoff
    handoff_payload = {
        "pickup_point": "Doc-Find desk, Akwa (Douala)",
        "handoff_time": "Tomorrow, 10:00"
    }
    hand_resp = client.post(f"/api/v1/admin/claims/{claim.id}/handoff", json=handoff_payload)
    assert hand_resp.status_code == 200
    assert hand_resp.json()["status"] == "handoff"

    # Admin message
    msg_resp = client.post(f"/api/v1/admin/claims/{claim.id}/messages", json={"text": "Please bring original card."})
    assert msg_resp.status_code == 200
    assert msg_resp.json()["text"] == "Please bring original card."

    # Mark as handed over
    done_resp = client.post(f"/api/v1/admin/claims/{claim.id}/handed-over")
    assert done_resp.status_code == 200
    assert done_resp.json()["status"] == "done"

    # Verify listing is now Recovered
    db_session.refresh(l)
    assert l.status == ListingStatus.RECOVERED


def test_admin_reject_and_flag_claim(client, db_session):
    l = Listing(
        document_type=DocumentType.PASS,
        town="Yaoundé",
        spot_description="Mvan",
        redacted_name="M•••• T••••",
        status=ListingStatus.LIVE,
        secret_question="What is your date of birth?",
        expected_answer="04 Aug 1991"
    )
    db_session.add(l)
    db_session.commit()

    claim = Claim(
        listing_id=l.id,
        claimant_name="Suspicious Actor",
        claimant_phone="699 00 00 00",
        submitted_answer="Wrong",
        is_matched=False,
        has_id_photo=False,
        risk_level=ClaimRisk.HIGH,
        status=ClaimStatus.NEW
    )
    db_session.add(claim)
    db_session.commit()

    rej_flag_resp = client.post(f"/api/v1/admin/claims/{claim.id}/reject-flag")
    assert rej_flag_resp.status_code == 200
    assert rej_flag_resp.json()["status"] == "rejected"

    # Verify added to fraud reports
    f_resp = client.get("/api/v1/admin/fraud")
    assert f_resp.status_code == 200
    assert any(f["who"] == "Suspicious Actor" for f in f_resp.json())


def test_admin_listings_lifecycle(client, db_session):
    l = Listing(
        document_type=DocumentType.BIRTH,
        town="Bafoussam",
        spot_description="Marché A",
        redacted_name="E•••• A••••",
        status=ListingStatus.LIVE,
        secret_question="What is your mother's first name?",
        expected_answer="Rosine"
    )
    db_session.add(l)
    db_session.commit()

    # Get admin listings
    resp = client.get("/api/v1/admin/listings?status=Live")
    assert resp.status_code == 200
    assert len(resp.json()) >= 1

    # Archive listing
    arch_resp = client.patch(f"/api/v1/admin/listings/{l.id}/status", json={"status": "Archived"})
    assert arch_resp.status_code == 200
    assert arch_resp.json()["status"] == "Archived"

    # Restore listing
    rest_resp = client.patch(f"/api/v1/admin/listings/{l.id}/status", json={"status": "Live"})
    assert rest_resp.status_code == 200
    assert rest_resp.json()["status"] == "Live"


def test_admin_fraud_suspension_and_dismissal(client, db_session):
    f1 = FraudReport(
        who="Marie Tchoua",
        why="Fake claims pattern",
        source_by="Automatic rule",
        severity=FraudSeverity.HIGH,
        status=FraudStatus.OPEN
    )
    f2 = FraudReport(
        who="Misunderstood Finder",
        why="Unverified external report",
        source_by="Finder report",
        severity=FraudSeverity.LOW,
        status=FraudStatus.OPEN
    )
    db_session.add_all([f1, f2])
    db_session.commit()

    # Suspend f1
    resp1 = client.post(f"/api/v1/admin/fraud/{f1.id}/suspend")
    assert resp1.status_code == 200
    assert "suspended" in resp1.json()["message"]

    # Dismiss f2
    resp2 = client.post(f"/api/v1/admin/fraud/{f2.id}/dismiss")
    assert resp2.status_code == 200
    assert "dismissed" in resp2.json()["message"]
