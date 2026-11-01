from sqlalchemy.orm import Session
from .models.user import User, UserRole
from .models.submission import DocumentSubmission, DocumentType, PhotoQuality, SubmissionStatus
from .models.listing import Listing, ListingStatus
from .models.claim import Claim, ClaimStatus, ClaimRisk, ClaimMessage
from .models.fraud import FraudReport, FraudSeverity, FraudStatus
from .models.audit import AuditLog
from .core.security import get_password_hash


def seed_database(db: Session):
    # Check if already seeded
    if db.query(User).first():
        return

    # 1. Users
    demo_user = User(
        email="demo@docfind.cm",
        phone="+237 670 000 000",
        full_name="Kevin Nkeng",
        hashed_password=get_password_hash("demo1234"),
        role=UserRole.USER,
        is_active=True
    )
    admin_user = User(
        email="admin@docfind.cm",
        phone="+237 690 000 000",
        full_name="Antony",
        hashed_password=get_password_hash("admin1234"),
        role=UserRole.ADMIN,
        is_active=True
    )
    db.add_all([demo_user, admin_user])
    db.commit()

    # 2. Submissions (Review Queue)
    sub1 = DocumentSubmission(
        document_type=DocumentType.ID,
        town="Douala",
        spot_description="Akwa, near Rond-point Deido",
        finder_name="Paul Mbarga",
        finder_phone="677 12 04 55",
        photo_consent=True,
        location_consent=True,
        phone_consent=True,
        photo_quality=PhotoQuality.SHARP,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json={"name": "Kevin Nkeng", "num": "1020 4457 8812", "dob": "12 Mar 1996", "addr": "Bonanjo, Douala"},
        redaction_json={"name": True, "num": True, "dob": True, "addr": True, "photo": True, "blur": 7}
    )
    sub2 = DocumentSubmission(
        document_type=DocumentType.PASS,
        town="Yaoundé",
        spot_description="Mvan bus park",
        finder_name="Sandrine Ewane",
        finder_phone="690 55 21 08",
        photo_consent=True,
        location_consent=True,
        phone_consent=True,
        photo_quality=PhotoQuality.BLURRY,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json={"name": "Marie Tchoua", "num": "CE 0481 2290", "dob": "04 Aug 1991", "addr": "Bastos, Yaoundé"},
        redaction_json={"name": True, "num": True, "dob": True, "addr": True, "photo": True, "blur": 7}
    )
    sub3 = DocumentSubmission(
        document_type=DocumentType.BIRTH,
        town="Bafoussam",
        spot_description="Marché A",
        finder_name="Hamidou Njoya",
        finder_phone="651 90 33 17",
        photo_consent=True,
        location_consent=True,
        phone_consent=True,
        photo_quality=PhotoQuality.SHARP,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json={"name": "Emmanuel Abena", "num": "N° 2209/2001", "dob": "22 Jan 2001", "addr": "Bafoussam II"},
        redaction_json={"name": True, "num": True, "dob": True, "addr": True, "photo": True, "blur": 7}
    )
    sub4 = DocumentSubmission(
        document_type=DocumentType.LIC,
        town="Douala",
        spot_description="Bonabéri ferry quay",
        finder_name="Ines Kameni",
        finder_phone="699 04 76 62",
        photo_consent=True,
        location_consent=True,
        phone_consent=False,
        photo_quality=PhotoQuality.SHARP,
        status=SubmissionStatus.PENDING_REVIEW,
        data_json={"name": "Felix Bella", "num": "PC 77 301 884", "dob": "30 Sep 1988", "addr": "Bonabéri, Douala"},
        redaction_json={"name": True, "num": True, "dob": True, "addr": True, "photo": True, "blur": 7}
    )
    db.add_all([sub1, sub2, sub3, sub4])
    db.commit()

    # 3. Seed Public Listings
    listings_data = [
        (DocumentType.ID, "Douala", "Akwa, near Rond-point Deido", "K•••• N••••••", ListingStatus.LIVE, 84, 1, "Which town issued your card?", "Douala"),
        (DocumentType.PASS, "Yaoundé", "Mvan bus park", "M•••• T••••", ListingStatus.LIVE, 61, 1, "What is your date of birth?", "04 Aug 1991"),
        (DocumentType.BIRTH, "Bafoussam", "Marché A", "E•••• A••••", ListingStatus.LIVE, 27, 1, "What is your mother's first name?", "Rosine"),
        (DocumentType.LIC, "Douala", "Bonabéri ferry quay", "F•••• B••••", ListingStatus.LIVE, 40, 1, "Which date is printed as the issue date?", "09 Feb 2021"),
        (DocumentType.ID, "Garoua", "Grand Marché", "A•••• N••••", ListingStatus.LIVE, 33, 0, "Which town issued your card?", "Garoua"),
        (DocumentType.BIRTH, "Bamenda", "Commercial Avenue", "J•••• T••••", ListingStatus.LIVE, 18, 0, "What is your mother's first name?", "Helene"),
        (DocumentType.ID, "Buea", "University of Buea gate", "S•••• M••••", ListingStatus.RECOVERED, 96, 1, "Which town issued your card?", "Buea"),
        (DocumentType.PASS, "Douala", "Deido taxi stand", "P•••• M••••", ListingStatus.ARCHIVED, 12, 0, "What is your date of birth?", "15 May 1985"),
    ]
    created_listings = []
    for dt, town, spot, name, st, views, claims, ques, ans in listings_data:
        l = Listing(
            document_type=dt,
            town=town,
            spot_description=spot,
            redacted_name=name,
            status=st,
            views_count=views,
            claims_count=claims,
            secret_question=ques,
            expected_answer=ans
        )
        db.add(l)
        created_listings.append(l)
    db.commit()

    # 4. Seed Claims
    c1 = Claim(
        listing_id=created_listings[0].id,
        claimant_id=demo_user.id,
        claimant_name="Kevin Nkeng",
        claimant_phone="677 98 10 22",
        submitted_answer="Douala",
        is_matched=True,
        has_id_photo=True,
        risk_level=ClaimRisk.LOW,
        risk_signals=["Name matches document", "Answer matches", "ID photo attached"],
        status=ClaimStatus.NEW
    )
    c1_msg = ClaimMessage(
        claim=c1,
        sender_type="u",
        text="Hello, I lost my ID card last Friday in a taxi."
    )

    c2 = Claim(
        listing_id=created_listings[1].id,
        claimant_name="Marie Tchoua",
        claimant_phone="690 21 77 03",
        submitted_answer="14 Aug 1991",
        is_matched=False,
        has_id_photo=False,
        risk_level=ClaimRisk.HIGH,
        risk_signals=["Answer is close but wrong", "No ID photo attached", "Same phone number claimed 2 other documents"],
        status=ClaimStatus.NEW
    )
    c2_msg = ClaimMessage(
        claim=c2,
        sender_type="u",
        text="That passport is mine, please call me."
    )
    db.add_all([c1, c1_msg, c2, c2_msg])
    db.commit()

    # 5. Fraud Reports
    f1 = FraudReport(
        who="Marie Tchoua",
        why="Wrong birth date in proof, no ID photo, and the same number claimed 2 other documents this week.",
        source_by="Automatic rule",
        severity=FraudSeverity.HIGH,
        status=FraudStatus.OPEN
    )
    f2 = FraudReport(
        who="Unknown claimant (+237 655 ••• 41)",
        why="Finder reported being asked to hand over a document outside the platform.",
        source_by="Finder report",
        severity=FraudSeverity.MEDIUM,
        status=FraudStatus.OPEN
    )
    db.add_all([f1, f2])
    db.commit()

    # 6. Audit Log
    a1 = AuditLog(actor_name="Antony", action="approved listing: ID card · Douala", is_sensitive=False)
    a2 = AuditLog(actor_name="Antony", action="revealed an original document photo (reason: redaction)", is_sensitive=True)
    a3 = AuditLog(actor_name="Antony", action="verified claim and scheduled handoff: Birth certificate · Bafoussam", is_sensitive=False)
    db.add_all([a1, a2, a3])
    db.commit()
