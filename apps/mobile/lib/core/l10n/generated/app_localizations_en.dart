// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Doc-Find';

  @override
  String get appTagline =>
      'Connecting found official documents with their owners in Cameroon.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSlide1Title => 'Lost an ID or passport?';

  @override
  String get onboardingSlide1Body =>
      'Search Cameroon-wide in seconds. If it\'s been found, your document is waiting safely.';

  @override
  String get onboardingSlide2Title => 'Found one? Report it fast.';

  @override
  String get onboardingSlide2Body =>
      'Snap a picture. We automatically redact personal info before anything goes public.';

  @override
  String get onboardingSlide3Title => 'A safe handoff, every time.';

  @override
  String get onboardingSlide3Body =>
      'Prove it\'s yours with one question. We coordinate the handoff—finders and owners never meet unverified.';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authWelcomeBackSub => 'Log in to find or return a document.';

  @override
  String get authCreateAccount => 'Create your account';

  @override
  String get authCreateAccountSub =>
      'Join Doc-Find to report or claim documents.';

  @override
  String get authLogIn => 'Log in';

  @override
  String get authRegister => 'Create account';

  @override
  String get authEmailOrPhone => 'Email or phone';

  @override
  String get authEmailOrPhoneHint => 'you@email.com or 6XXXXXXXX';

  @override
  String get authFullName => 'Full name';

  @override
  String get authFullNameHint => 'Your full name';

  @override
  String get authPhone => 'Phone number (+237)';

  @override
  String get authPhoneHint => '6XX XXX XXX';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'you@email.com';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordHint => 'At least 6 characters';

  @override
  String get authConsentLaw =>
      'I agree that Doc-Find stores my name, phone and email to run this service (Law No. 2024/017). I can withdraw anytime.';

  @override
  String get authDemoHint => 'Demo: demo@docfind.cm · demo1234';

  @override
  String get authFillIn => 'Fill in';

  @override
  String get authInvalidCredentials => 'Invalid email/phone or password.';

  @override
  String get authDuplicateAccount =>
      'An account with this email or phone already exists.';

  @override
  String authWelcomeToast(String name) {
    return 'Welcome, $name';
  }

  @override
  String get navSearch => 'Search';

  @override
  String get navReport => 'Report';

  @override
  String get navMessages => 'Messages';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get searchTitle => 'Find a lost document';

  @override
  String get searchPlaceholder => 'Town or name, e.g. Bafoussam';

  @override
  String get searchAllTypes => 'All';

  @override
  String get searchAllTowns => 'All towns';

  @override
  String get searchAnyDate => 'Any date';

  @override
  String get searchLast7Days => 'Last 7 days';

  @override
  String get searchLast30Days => 'Last 30 days';

  @override
  String get searchAlertMe => 'Alert me for this search';

  @override
  String searchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents found',
      one: '1 document found',
      zero: 'No documents found',
    );
    return '$_temp0';
  }

  @override
  String get searchEmptyTitle => 'No match yet';

  @override
  String get searchEmptyBody =>
      'Try another town or date, or tap \'Alert me for this search\'. We\'ll tell you when one appears.';

  @override
  String get docTypeId => 'ID card';

  @override
  String get docTypePassport => 'Passport';

  @override
  String get docTypeBirth => 'Birth certificate';

  @override
  String get docTypeLicence => 'Driver\'s licence';

  @override
  String get docTypeOther => 'Other';

  @override
  String get detailTitle => 'Document details';

  @override
  String get detailFoundIn => 'Found in';

  @override
  String get detailPlace => 'Place';

  @override
  String get detailDate => 'Date';

  @override
  String get detailNote => 'Note';

  @override
  String get detailStatus => 'Status';

  @override
  String get detailHeldSafely => 'Held safely by our team';

  @override
  String get detailPrivacyNote =>
      'Personal numbers and photo are redacted to protect the owner\'s privacy. To claim this document, you must answer a verification question.';

  @override
  String get detailClaimCTA => 'This is my document';

  @override
  String get claimSheetTitle => 'Prove it\'s yours';

  @override
  String get claimSheetSubtitle =>
      'Answer the question printed on the document so our team can verify.';

  @override
  String get claimQuestionId => 'Which town issued your card?';

  @override
  String get claimQuestionPassport => 'What is your date of birth?';

  @override
  String get claimQuestionBirth => 'What is your mother\'s first name?';

  @override
  String get claimQuestionOther => 'Which date is printed as the issue date?';

  @override
  String get claimAnswerPlaceholder => 'Your answer';

  @override
  String get claimAddPhoto => 'Add photo of matching ID (optional)';

  @override
  String get claimSubmit => 'Submit claim';

  @override
  String get claimCreatedToast => 'Claim submitted. Chat with the team below.';

  @override
  String get reportTitle => 'Report a found document';

  @override
  String get reportStep1Title => 'Take a photo of the document';

  @override
  String get reportStep1Subtitle =>
      'Align the document inside the frame. We will redact personal details before publishing.';

  @override
  String get reportRetake => 'Retake photo';

  @override
  String get reportNext => 'Continue';

  @override
  String get reportStep2Title => 'Where was it found?';

  @override
  String get reportTypeLabel => 'Document type';

  @override
  String get reportTownLabel => 'Town';

  @override
  String get reportExactPlaceLabel => 'Exact place found';

  @override
  String get reportExactPlaceHint => 'e.g. Taxi stand Akwa, near bakery';

  @override
  String get reportNoteLabel => 'Optional note';

  @override
  String get reportNoteHint =>
      'Any detail to help identify it without revealing private data';

  @override
  String get reportStep3Title => 'Consent & legal submission';

  @override
  String get reportConsent1 =>
      'I consent to Doc-Find storing and processing the document photo to identify the owner, in accordance with Cameroon Law No. 2024/017.';

  @override
  String get reportConsent2 =>
      'I consent to Doc-Find contacting me via phone strictly to coordinate handoff with the verified owner.';

  @override
  String get reportSubmit => 'Submit for review';

  @override
  String get reportSuccessTitle => 'Thank you!';

  @override
  String get reportSuccessSubtitle =>
      'Your report has been received. Our moderation team is reviewing it.';

  @override
  String get reportTimelineReceived => 'Report received';

  @override
  String get reportTimelineReview => 'Team review & redaction';

  @override
  String get reportTimelinePosted => 'Posted with redaction';

  @override
  String get reportTimelineHandoff => 'Handoff with owner';

  @override
  String get reportRecentReports => 'Your recent reports';

  @override
  String get reportStatusInReview => 'In review';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesSupportName => 'Doc-Find team';

  @override
  String get messagesOfficialBadge => 'Official Support';

  @override
  String get messagesTypeMessage => 'Type a message...';

  @override
  String get messagesSend => 'Send';

  @override
  String get alertsTitle => 'Saved search alerts';

  @override
  String get alertsSubtitle =>
      'We notify you via Push and SMS as soon as a matching document is posted.';

  @override
  String get alertsEnabled => 'Push + SMS when posted';

  @override
  String get alertsPaused => 'Paused';

  @override
  String get alertsSavedToast => 'Alert saved for this search';

  @override
  String get profileTitle => 'Profile & settings';

  @override
  String get profileAvatarColor => 'Avatar color';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileDefaultTown => 'Default town';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profilePush => 'Push notifications';

  @override
  String get profileSms => 'SMS alerts';

  @override
  String get profileEmail => 'Email receipts';

  @override
  String get profilePrivacySecurity => 'Privacy & security';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileDownloadData => 'Download my data';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileSavedToast => 'Profile updated successfully';
}
