def test_submit_without_consent_fails(client):
    payload = {
        "document_type": "id",
        "town": "Douala",
        "spot_description": "Near Akwa pharmacy",
        "finder_name": "Paul Mbarga",
        "finder_phone": "+237 677 120 455",
        "photo_consent": False,
        "location_consent": True,
        "phone_consent": True,
        "photo_quality": "Sharp",
        "data": {
            "name": "Kevin Nkeng",
            "num": "1020 4457 8812",
            "dob": "12 Mar 1996",
            "addr": "Bonanjo"
        }
    }
    response = client.post("/api/v1/submissions/", json=payload)
    assert response.status_code == 400
    assert "Law No. 2024/017" in response.json()["detail"]


def test_submit_with_consent_succeeds(client):
    payload = {
        "document_type": "id",
        "town": "Douala",
        "spot_description": "Near Akwa pharmacy",
        "finder_name": "Paul Mbarga",
        "finder_phone": "+237 677 120 455",
        "photo_consent": True,
        "location_consent": True,
        "phone_consent": True,
        "photo_quality": "Sharp",
        "data": {
            "name": "Kevin Nkeng",
            "num": "1020 4457 8812",
            "dob": "12 Mar 1996",
            "addr": "Bonanjo"
        }
    }
    response = client.post("/api/v1/submissions/", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["town"] == "Douala"
    assert data["status"] == "pending_review"
