def test_register_without_consent_fails(client):
    payload = {
        "full_name": "New User",
        "email": "new@docfind.cm",
        "phone": "+237 671 234 567",
        "password": "password123",
        "consent": False
    }
    response = client.post("/api/v1/auth/register", json=payload)
    assert response.status_code == 400
    assert "Law No. 2024/017" in response.json()["detail"]


def test_register_with_consent_succeeds(client):
    payload = {
        "full_name": "New User",
        "email": "newuser@docfind.cm",
        "phone": "+237 671 999 888",
        "password": "password123",
        "consent": True
    }
    response = client.post("/api/v1/auth/register", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "newuser@docfind.cm"
    assert data["full_name"] == "New User"


def test_login_success_and_get_me(client):
    # Login with demo user
    response = client.post(
        "/api/v1/auth/login",
        json={"email_or_phone": "demo@docfind.cm", "password": "demo1234"}
    )
    assert response.status_code == 200
    token_data = response.json()
    assert "access_token" in token_data
    token = token_data["access_token"]

    # Call /me with token
    headers = {"Authorization": f"Bearer {token}"}
    me_resp = client.get("/api/v1/auth/me", headers=headers)
    assert me_resp.status_code == 200
    assert me_resp.json()["email"] == "demo@docfind.cm"


def test_login_invalid_password(client):
    response = client.post(
        "/api/v1/auth/login",
        json={"email_or_phone": "demo@docfind.cm", "password": "wrongpassword"}
    )
    assert response.status_code == 401
