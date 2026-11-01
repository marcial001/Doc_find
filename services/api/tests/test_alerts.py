def test_alerts_lifecycle(client):
    # Log in first to get auth token
    login_resp = client.post(
        "/api/v1/auth/login",
        json={"email_or_phone": "demo@docfind.cm", "password": "demo1234"}
    )
    assert login_resp.status_code == 200
    token = login_resp.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    # Create alert
    alert_payload = {
        "document_type": "id",
        "town": "Douala"
    }
    create_resp = client.post("/api/v1/alerts/", json=alert_payload, headers=headers)
    assert create_resp.status_code == 201
    alert_data = create_resp.json()
    assert alert_data["town"] == "Douala"
    assert alert_data["is_active"] is True

    # List alerts
    list_resp = client.get("/api/v1/alerts/", headers=headers)
    assert list_resp.status_code == 200
    assert len(list_resp.json()) >= 1

    # Delete alert
    del_resp = client.delete(f"/api/v1/alerts/{alert_data['id']}", headers=headers)
    assert del_resp.status_code == 204
