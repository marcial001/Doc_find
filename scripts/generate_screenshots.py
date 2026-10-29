import os
import subprocess
import time

CHROME = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
SCREENSHOTS_DIR = os.path.abspath("design/screenshots")
os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

with open("design/doc-find.html", "r", encoding="utf-8") as f:
    mobile_html_base = f.read()

with open("design/doc-find-admin.html", "r", encoding="utf-8") as f:
    admin_html_base = f.read()

def capture_page(html_content, output_name, width=390, height=844, wait_sec=0.2):
    temp_file = os.path.abspath(f"temp_{output_name}.html")
    with open(temp_file, "w", encoding="utf-8") as f:
        f.write(html_content)
    
    out_path = os.path.join(SCREENSHOTS_DIR, output_name)
    url = "file:///" + temp_file.replace("\\", "/")
    
    cmd = [
        CHROME,
        "--headless=new",
        "--disable-gpu",
        "--no-sandbox",
        f"--window-size={width},{height}",
        "--hide-scrollbars",
        f"--screenshot={out_path}",
        url
    ]
    subprocess.run(cmd, capture_output=True)
    if os.path.exists(temp_file):
        os.remove(temp_file)
    
    if os.path.exists(out_path):
        print(f"Captured: {output_name} ({os.path.getsize(out_path)} bytes)")
    else:
        print(f"FAILED: {output_name}")

mock_user = "{name: 'K. N.', email: 'demo@docfind.cm', phone: '670000000', col: '#0E6B47'}"

mobile_states = [
    # 1. Splash
    ("mobile_01_splash.png", """
        $('#splash').style.display = 'flex';
        $('#splash').style.opacity = '1';
    """),
    
    # 2. Onboarding slide 1
    ("mobile_02_onboarding_slide1.png", """
        hideSplash();
        drawIntro();
        $('#intro').classList.add('on');
        S.isl = 0;
        itrack.style.transform = 'translateX(0%)';
        document.querySelectorAll('#idots span').forEach((e,i)=>e.classList.toggle('on',i===0));
        $('#inx').textContent = 'Next';
    """),

    # 3. Onboarding slide 2
    ("mobile_03_onboarding_slide2.png", """
        hideSplash();
        drawIntro();
        $('#intro').classList.add('on');
        S.isl = 1;
        itrack.style.transform = 'translateX(-33.333%)';
        document.querySelectorAll('#idots span').forEach((e,i)=>e.classList.toggle('on',i===1));
        $('#inx').textContent = 'Next';
    """),

    # 4. Onboarding slide 3
    ("mobile_04_onboarding_slide3.png", """
        hideSplash();
        drawIntro();
        $('#intro').classList.add('on');
        S.isl = 2;
        itrack.style.transform = 'translateX(-66.666%)';
        document.querySelectorAll('#idots span').forEach((e,i)=>e.classList.toggle('on',i===2));
        $('#inx').textContent = 'Get started';
    """),

    # 5. Auth Login
    ("mobile_05_auth_login.png", """
        hideSplash();
        endIntro();
        authMode('login');
        $('#auth').classList.remove('off');
        $('#auth').classList.add('on');
    """),

    # 6. Auth Register
    ("mobile_06_auth_register.png", """
        hideSplash();
        endIntro();
        authMode('reg');
        $('#auth').classList.remove('off');
        $('#auth').classList.add('on');
    """),

    # 7. Auth Login Error
    ("mobile_07_auth_error.png", """
        hideSplash();
        endIntro();
        authMode('login');
        $('#auth').classList.remove('off');
        $('#auth').classList.add('on');
        bad('Invalid email or password');
    """),

    # 8. Search default (home)
    ("mobile_08_search_default.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
    """),

    # 9. Search filtered by ID card
    ("mobile_09_search_filter_id.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
        S.type = 'id';
        initSearch();
        renderList();
    """),

    # 10. Search empty state
    ("mobile_10_search_empty.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
        S.q = 'NonexistentNameXYZ';
        $('#q').value = S.q;
        renderList();
    """),

    # 11. Listing detail
    ("mobile_11_listing_detail.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
        openDetail(1);
    """),

    # 12. Claim bottom sheet
    ("mobile_12_claim_sheet.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
        openDetail(1);
        openClaim();
    """),

    # 13. Report Step 1 viewfinder
    ("mobile_13_report_step1_viewfinder.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        openReport();
        R.s = 0;
        R.photo = false;
        drawR();
    """),

    # 14. Report Step 1 photo preview
    ("mobile_14_report_step1_preview.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        openReport();
        R.s = 0;
        R.photo = true;
        drawR();
    """),

    # 15. Report Step 2 details
    ("mobile_15_report_step2_details.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        openReport();
        R.s = 1;
        R.photo = true;
        drawR();
    """),

    # 16. Report Step 3 consent
    ("mobile_16_report_step3_consent.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        openReport();
        R.s = 2;
        R.photo = true;
        drawR();
    """),

    # 17. Report Success timeline
    ("mobile_17_report_success.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        openReport();
        R.s = 3;
        drawR();
    """),

    # 18. Messages threads
    ("mobile_18_messages_threads.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('msg');
        renderThreads();
    """),

    # 19. Messages Chat view
    ("mobile_19_messages_chat.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('msg');
        openChat(0);
    """),

    # 20. Alerts tab
    ("mobile_20_alerts.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('alerts');
        renderAlerts();
    """),

    # 21. Profile & settings
    ("mobile_21_profile_settings.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        openProfile();
    """),

    # 22. Toast notification
    ("mobile_22_toast.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
        toast('Alert saved for ID card in Douala');
    """),

    # 23. Dark mode search
    ("mobile_23_dark_mode.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
        document.documentElement.setAttribute('data-theme', 'dark');
    """),

    # 24. French locale search
    ("mobile_24_french_locale.png", f"""
        hideSplash();
        endIntro();
        login({mock_user});
        go('search');
        setLang('fr');
    """),
]

style_override = """
<style>
@media (max-width: 500px), (min-width: 0px) {
    html, body { margin: 0; padding: 0; width: 100%; height: 100%; background: var(--surf) !important; }
    .phone { width: 100% !important; height: 100% !important; border-radius: 0 !important; box-shadow: none !important; max-width: none !important; max-height: none !important; }
}
</style>
"""

for filename, js_setup in mobile_states:
    script_injection = f"""
    <script>
    window.addEventListener('DOMContentLoaded', () => {{
        {js_setup}
    }});
    </script>
    """
    content = mobile_html_base.replace("</head>", f"{style_override}</head>").replace("</body>", f"{script_injection}</body>")
    capture_page(content, filename, 390, 844)

# Admin states
admin_states = [
    ("admin_01_overview.png", "overview", 1280, 800, """
        document.querySelectorAll('[data-n]').forEach(e => e.textContent = e.dataset.n);
    """),
    ("admin_02_review_queue.png", "q", 1280, 800, ""),
    ("admin_03_review_queue_revealed.png", "q", 1280, 800, "reveal();"),
    ("admin_04_claims.png", "claims", 1280, 800, ""),
    ("admin_05_claims_handoff_sheet.png", "claims", 1280, 800, "handSheet(C[0].id);"),
    ("admin_06_listings.png", "listings", 1280, 800, ""),
    ("admin_07_listings_bulk_sheet.png", "listings", 1280, 800, "bulk();"),
    ("admin_08_fraud_reports.png", "fraud", 1280, 800, ""),
    ("admin_09_audit_log.png", "audit", 1280, 800, ""),
    ("admin_10_settings.png", "settings", 1280, 800, ""),
    ("admin_11_responsive_mobile.png", "overview", 390, 844, """
        document.querySelectorAll('[data-n]').forEach(e => e.textContent = e.dataset.n);
    """),
]

for filename, tab, w, h, extra_js in admin_states:
    script_injection = f"""
    <script>
    window.addEventListener('DOMContentLoaded', () => {{
        location.hash = '#{tab}';
        go();
        {extra_js}
    }});
    </script>
    """
    content = admin_html_base.replace("</body>", f"{script_injection}</body>")
    capture_page(content, filename, w, h)

print("Screenshots generation complete!")
