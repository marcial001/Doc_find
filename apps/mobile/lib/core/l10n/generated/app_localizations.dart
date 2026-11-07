import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Doc-Find'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Connecting found official documents with their owners in Cameroon.'**
  String get appTagline;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Lost an ID or passport?'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Search Cameroon-wide in seconds. If it\'s been found, your document is waiting safely.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Found one? Report it fast.'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'Snap a picture. We automatically redact personal info before anything goes public.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'A safe handoff, every time.'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Prove it\'s yours with one question. We coordinate the handoff—finders and owners never meet unverified.'**
  String get onboardingSlide3Body;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// No description provided for @authWelcomeBackSub.
  ///
  /// In en, this message translates to:
  /// **'Log in to find or return a document.'**
  String get authWelcomeBackSub;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authCreateAccount;

  /// No description provided for @authCreateAccountSub.
  ///
  /// In en, this message translates to:
  /// **'Join Doc-Find to report or claim documents.'**
  String get authCreateAccountSub;

  /// No description provided for @authLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authLogIn;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegister;

  /// No description provided for @authEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get authEmailOrPhone;

  /// No description provided for @authEmailOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'you@email.com or 6XXXXXXXX'**
  String get authEmailOrPhoneHint;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullName;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get authFullNameHint;

  /// No description provided for @authPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number (+237)'**
  String get authPhone;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'6XX XXX XXX'**
  String get authPhoneHint;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@email.com'**
  String get authEmailHint;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get authPasswordHint;

  /// No description provided for @authConsentLaw.
  ///
  /// In en, this message translates to:
  /// **'I agree that Doc-Find stores my name, phone and email to run this service (Law No. 2024/017). I can withdraw anytime.'**
  String get authConsentLaw;

  /// No description provided for @authDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo: demo@docfind.cm · demo1234'**
  String get authDemoHint;

  /// No description provided for @authFillIn.
  ///
  /// In en, this message translates to:
  /// **'Fill in'**
  String get authFillIn;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email/phone or password.'**
  String get authInvalidCredentials;

  /// No description provided for @authDuplicateAccount.
  ///
  /// In en, this message translates to:
  /// **'An account with this email or phone already exists.'**
  String get authDuplicateAccount;

  /// No description provided for @authWelcomeToast.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String authWelcomeToast(String name);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get navReport;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @homeHeroTitle1.
  ///
  /// In en, this message translates to:
  /// **'Lost or Found a Document?'**
  String get homeHeroTitle1;

  /// No description provided for @homeHeroSub1.
  ///
  /// In en, this message translates to:
  /// **'Cameroon\'s national recovery platform connecting lost IDs, Passports, and Certificates safely.'**
  String get homeHeroSub1;

  /// No description provided for @homeHeroAction1.
  ///
  /// In en, this message translates to:
  /// **'Search Documents'**
  String get homeHeroAction1;

  /// No description provided for @homeHeroTitle2.
  ///
  /// In en, this message translates to:
  /// **'Privacy by Law No. 2024/017'**
  String get homeHeroTitle2;

  /// No description provided for @homeHeroSub2.
  ///
  /// In en, this message translates to:
  /// **'Every document photo is automatically masked and encrypted. Sensitive PII stays protected.'**
  String get homeHeroSub2;

  /// No description provided for @homeHeroAction2.
  ///
  /// In en, this message translates to:
  /// **'Privacy Protected'**
  String get homeHeroAction2;

  /// No description provided for @homeHeroTitle3.
  ///
  /// In en, this message translates to:
  /// **'Verified Safe Handoffs'**
  String get homeHeroTitle3;

  /// No description provided for @homeHeroSub3.
  ///
  /// In en, this message translates to:
  /// **'Secret questions and official partner points protect both finder and owner during return.'**
  String get homeHeroSub3;

  /// No description provided for @homeHeroAction3.
  ///
  /// In en, this message translates to:
  /// **'Report a Document'**
  String get homeHeroAction3;

  /// No description provided for @homeHeroTitle4.
  ///
  /// In en, this message translates to:
  /// **'Instant Cameroon-Wide Alerts'**
  String get homeHeroTitle4;

  /// No description provided for @homeHeroSub4.
  ///
  /// In en, this message translates to:
  /// **'Create personalized alerts for your town or document and get notified the moment it is found.'**
  String get homeHeroSub4;

  /// No description provided for @homeHeroAction4.
  ///
  /// In en, this message translates to:
  /// **'Set Search Alert'**
  String get homeHeroAction4;

  /// No description provided for @homeQuickSearch.
  ///
  /// In en, this message translates to:
  /// **'Search Lost'**
  String get homeQuickSearch;

  /// No description provided for @homeQuickReport.
  ///
  /// In en, this message translates to:
  /// **'Report Found'**
  String get homeQuickReport;

  /// No description provided for @homeQuickAlerts.
  ///
  /// In en, this message translates to:
  /// **'New Alert'**
  String get homeQuickAlerts;

  /// No description provided for @homeRecentDocs.
  ///
  /// In en, this message translates to:
  /// **'Recently Found Documents'**
  String get homeRecentDocs;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @homeChatAdmin.
  ///
  /// In en, this message translates to:
  /// **'Chat with Admin'**
  String get homeChatAdmin;

  /// No description provided for @homeChatAdminTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open direct chat with Doc-Find Admin'**
  String get homeChatAdminTooltip;

  /// No description provided for @homeTrustBadge.
  ///
  /// In en, this message translates to:
  /// **'Complies with Cameroon Data Protection Law No. 2024/017'**
  String get homeTrustBadge;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a lost document'**
  String get searchTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Town or name, e.g. Bafoussam'**
  String get searchPlaceholder;

  /// No description provided for @searchAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchAllTypes;

  /// No description provided for @searchAllTowns.
  ///
  /// In en, this message translates to:
  /// **'All towns'**
  String get searchAllTowns;

  /// No description provided for @searchAnyDate.
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get searchAnyDate;

  /// No description provided for @searchLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get searchLast7Days;

  /// No description provided for @searchLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get searchLast30Days;

  /// No description provided for @searchAlertMe.
  ///
  /// In en, this message translates to:
  /// **'Alert me for this search'**
  String get searchAlertMe;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No documents found} =1{1 document found} other{{count} documents found}}'**
  String searchResultsCount(int count);

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No match yet'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another town or date, or tap \'Alert me for this search\'. We\'ll tell you when one appears.'**
  String get searchEmptyBody;

  /// No description provided for @docTypeId.
  ///
  /// In en, this message translates to:
  /// **'ID card'**
  String get docTypeId;

  /// No description provided for @docTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get docTypePassport;

  /// No description provided for @docTypeBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth certificate'**
  String get docTypeBirth;

  /// No description provided for @docTypeLicence.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s licence'**
  String get docTypeLicence;

  /// No description provided for @docTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docTypeOther;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Document details'**
  String get detailTitle;

  /// No description provided for @detailFoundIn.
  ///
  /// In en, this message translates to:
  /// **'Found in'**
  String get detailFoundIn;

  /// No description provided for @detailPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get detailPlace;

  /// No description provided for @detailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get detailDate;

  /// No description provided for @detailNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get detailNote;

  /// No description provided for @detailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get detailStatus;

  /// No description provided for @detailHeldSafely.
  ///
  /// In en, this message translates to:
  /// **'Held safely by our team'**
  String get detailHeldSafely;

  /// No description provided for @detailPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Personal numbers and photo are redacted to protect the owner\'s privacy. To claim this document, you must answer a verification question.'**
  String get detailPrivacyNote;

  /// No description provided for @detailClaimCTA.
  ///
  /// In en, this message translates to:
  /// **'This is my document'**
  String get detailClaimCTA;

  /// No description provided for @claimSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Prove it\'s yours'**
  String get claimSheetTitle;

  /// No description provided for @claimSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answer the question printed on the document so our team can verify.'**
  String get claimSheetSubtitle;

  /// No description provided for @claimQuestionId.
  ///
  /// In en, this message translates to:
  /// **'Which town issued your card?'**
  String get claimQuestionId;

  /// No description provided for @claimQuestionPassport.
  ///
  /// In en, this message translates to:
  /// **'What is your date of birth?'**
  String get claimQuestionPassport;

  /// No description provided for @claimQuestionBirth.
  ///
  /// In en, this message translates to:
  /// **'What is your mother\'s first name?'**
  String get claimQuestionBirth;

  /// No description provided for @claimQuestionOther.
  ///
  /// In en, this message translates to:
  /// **'Which date is printed as the issue date?'**
  String get claimQuestionOther;

  /// No description provided for @claimAnswerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get claimAnswerPlaceholder;

  /// No description provided for @claimAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo of matching ID (optional)'**
  String get claimAddPhoto;

  /// No description provided for @claimSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit claim'**
  String get claimSubmit;

  /// No description provided for @claimCreatedToast.
  ///
  /// In en, this message translates to:
  /// **'Claim submitted. Chat with the team below.'**
  String get claimCreatedToast;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report a found document'**
  String get reportTitle;

  /// No description provided for @reportStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the document'**
  String get reportStep1Title;

  /// No description provided for @reportStep1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Align the document inside the frame. We will redact personal details before publishing.'**
  String get reportStep1Subtitle;

  /// No description provided for @reportRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake photo'**
  String get reportRetake;

  /// No description provided for @reportNext.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get reportNext;

  /// No description provided for @reportStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Where was it found?'**
  String get reportStep2Title;

  /// No description provided for @reportTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get reportTypeLabel;

  /// No description provided for @reportTownLabel.
  ///
  /// In en, this message translates to:
  /// **'Town'**
  String get reportTownLabel;

  /// No description provided for @reportExactPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Exact place found'**
  String get reportExactPlaceLabel;

  /// No description provided for @reportExactPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Taxi stand Akwa, near bakery'**
  String get reportExactPlaceHint;

  /// No description provided for @reportNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get reportNoteLabel;

  /// No description provided for @reportNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Any detail to help identify it without revealing private data'**
  String get reportNoteHint;

  /// No description provided for @reportStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Consent & legal submission'**
  String get reportStep3Title;

  /// No description provided for @reportConsent1.
  ///
  /// In en, this message translates to:
  /// **'I consent to Doc-Find storing and processing the document photo to identify the owner, in accordance with Cameroon Law No. 2024/017.'**
  String get reportConsent1;

  /// No description provided for @reportConsent2.
  ///
  /// In en, this message translates to:
  /// **'I consent to Doc-Find contacting me via phone strictly to coordinate handoff with the verified owner.'**
  String get reportConsent2;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit for review'**
  String get reportSubmit;

  /// No description provided for @reportSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get reportSuccessTitle;

  /// No description provided for @reportSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your report has been received. Our moderation team is reviewing it.'**
  String get reportSuccessSubtitle;

  /// No description provided for @reportTimelineReceived.
  ///
  /// In en, this message translates to:
  /// **'Report received'**
  String get reportTimelineReceived;

  /// No description provided for @reportTimelineReview.
  ///
  /// In en, this message translates to:
  /// **'Team review & redaction'**
  String get reportTimelineReview;

  /// No description provided for @reportTimelinePosted.
  ///
  /// In en, this message translates to:
  /// **'Posted with redaction'**
  String get reportTimelinePosted;

  /// No description provided for @reportTimelineHandoff.
  ///
  /// In en, this message translates to:
  /// **'Handoff with owner'**
  String get reportTimelineHandoff;

  /// No description provided for @reportRecentReports.
  ///
  /// In en, this message translates to:
  /// **'Your recent reports'**
  String get reportRecentReports;

  /// No description provided for @reportStatusInReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get reportStatusInReview;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagesSupportName.
  ///
  /// In en, this message translates to:
  /// **'Doc-Find team'**
  String get messagesSupportName;

  /// No description provided for @messagesOfficialBadge.
  ///
  /// In en, this message translates to:
  /// **'Official Support'**
  String get messagesOfficialBadge;

  /// No description provided for @messagesTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get messagesTypeMessage;

  /// No description provided for @messagesSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get messagesSend;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved search alerts'**
  String get alertsTitle;

  /// No description provided for @alertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We notify you via Push and SMS as soon as a matching document is posted.'**
  String get alertsSubtitle;

  /// No description provided for @alertsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Push + SMS when posted'**
  String get alertsEnabled;

  /// No description provided for @alertsPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get alertsPaused;

  /// No description provided for @alertsSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Alert saved for this search'**
  String get alertsSavedToast;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & settings'**
  String get profileTitle;

  /// No description provided for @profileAvatarColor.
  ///
  /// In en, this message translates to:
  /// **'Avatar color'**
  String get profileAvatarColor;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profileThemeSystem;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileDefaultTown.
  ///
  /// In en, this message translates to:
  /// **'Default town'**
  String get profileDefaultTown;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profilePush.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get profilePush;

  /// No description provided for @profileSms.
  ///
  /// In en, this message translates to:
  /// **'SMS alerts'**
  String get profileSms;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email receipts'**
  String get profileEmail;

  /// No description provided for @profilePrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get profilePrivacySecurity;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePassword;

  /// No description provided for @profileDownloadData.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get profileDownloadData;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileSavedToast;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
