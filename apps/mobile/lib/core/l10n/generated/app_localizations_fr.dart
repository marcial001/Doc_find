// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Doc-Find';

  @override
  String get appTagline =>
      'Connecter les documents officiels trouvés à leurs propriétaires au Cameroun.';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingSlide1Title => 'Perdu une pièce d\'identité ?';

  @override
  String get onboardingSlide1Body =>
      'Recherchez dans tout le Cameroun en quelques secondes. Si elle a été trouvée, votre pièce vous attend en toute sécurité.';

  @override
  String get onboardingSlide2Title => 'Trouvé un document ? Signalez-le.';

  @override
  String get onboardingSlide2Body =>
      'Prenez une photo. Nous masquons automatiquement les données personnelles avant toute publication.';

  @override
  String get onboardingSlide3Title => 'Une remise sécurisée, toujours.';

  @override
  String get onboardingSlide3Body =>
      'Prouvez votre identité en une question. Nous organisons la remise sans contact direct non vérifié.';

  @override
  String get authWelcomeBack => 'Bon retour';

  @override
  String get authWelcomeBackSub =>
      'Connectez-vous pour trouver ou restituer un document.';

  @override
  String get authCreateAccount => 'Créez votre compte';

  @override
  String get authCreateAccountSub =>
      'Rejoignez Doc-Find pour signaler ou réclamer un document.';

  @override
  String get authLogIn => 'Connexion';

  @override
  String get authRegister => 'Créer un compte';

  @override
  String get authEmailOrPhone => 'Email ou téléphone';

  @override
  String get authEmailOrPhoneHint => 'vous@email.com ou 6XXXXXXXX';

  @override
  String get authFullName => 'Nom complet';

  @override
  String get authFullNameHint => 'Votre nom complet';

  @override
  String get authPhone => 'Numéro de téléphone (+237)';

  @override
  String get authPhoneHint => '6XX XXX XXX';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'vous@email.com';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authPasswordHint => 'Au moins 6 caractères';

  @override
  String get authConsentLaw =>
      'J\'accepte que Doc-Find conserve mes coordonnées pour ce service (Loi n° 2024/017). Retrait possible à tout moment.';

  @override
  String get authDemoHint => 'Démo : demo@docfind.cm · demo1234';

  @override
  String get authFillIn => 'Remplir';

  @override
  String get authInvalidCredentials =>
      'Email/téléphone ou mot de passe incorrect.';

  @override
  String get authDuplicateAccount =>
      'Un compte avec cet email ou téléphone existe déjà.';

  @override
  String authWelcomeToast(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get navHome => 'Accueil';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navReport => 'Signaler';

  @override
  String get navMessages => 'Messages';

  @override
  String get navAlerts => 'Alertes';

  @override
  String get homeHeroTitle1 => 'Document perdu ou retrouvé ?';

  @override
  String get homeHeroSub1 =>
      'La plateforme nationale au Cameroun qui connecte vos CNI, passeports et actes perdus en toute sécurité.';

  @override
  String get homeHeroAction1 => 'Rechercher un document';

  @override
  String get homeHeroTitle2 => 'Protection Loi N° 2024/017';

  @override
  String get homeHeroSub2 =>
      'Toutes les photos sont automatiquement masquées et chiffrées. Les données personnelles sensibles restent protégées.';

  @override
  String get homeHeroAction2 => 'Confidentialité garantie';

  @override
  String get homeHeroTitle3 => 'Remises sécurisées et vérifiées';

  @override
  String get homeHeroSub3 =>
      'Une question secrète et des points relais officiels protègent propriétaire et inventeur lors de la restitution.';

  @override
  String get homeHeroAction3 => 'Signaler un document';

  @override
  String get homeHeroTitle4 => 'Alertes instantanées 10 régions';

  @override
  String get homeHeroSub4 =>
      'Créez une alerte personnalisée pour votre ville ou type de pièce et soyez alerté dès sa publication.';

  @override
  String get homeHeroAction4 => 'Créer une alerte';

  @override
  String get homeQuickSearch => 'Recherche';

  @override
  String get homeQuickReport => 'Signaler';

  @override
  String get homeQuickAlerts => 'Nouvelle alerte';

  @override
  String get homeRecentDocs => 'Documents récemment signalés';

  @override
  String get homeViewAll => 'Tout voir';

  @override
  String get homeChatAdmin => 'Contacter l\'administrateur';

  @override
  String get homeChatAdminTooltip =>
      'Discuter directement avec l\'administration Doc-Find';

  @override
  String get homeTrustBadge =>
      'Conforme à la Loi N° 2024/017 sur la protection des données au Cameroun';

  @override
  String get searchTitle => 'Trouver un document perdu';

  @override
  String get searchPlaceholder => 'Ville ou nom, ex. Bafoussam';

  @override
  String get searchAllTypes => 'Tous';

  @override
  String get searchAllTowns => 'Toutes les villes';

  @override
  String get searchAnyDate => 'Toute date';

  @override
  String get searchLast7Days => '7 derniers jours';

  @override
  String get searchLast30Days => '30 derniers jours';

  @override
  String get searchAlertMe => 'M\'alerter pour cette recherche';

  @override
  String searchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents trouvés',
      one: '1 document trouvé',
      zero: 'Aucun document trouvé',
    );
    return '$_temp0';
  }

  @override
  String get searchEmptyTitle => 'Aucun résultat';

  @override
  String get searchEmptyBody =>
      'Essayez une autre ville ou date, ou touchez « M\'alerter pour cette recherche ». Nous vous prévenons dès qu\'un document apparaît.';

  @override
  String get docTypeId => 'Carte d\'identité';

  @override
  String get docTypePassport => 'Passeport';

  @override
  String get docTypeBirth => 'Acte de naissance';

  @override
  String get docTypeLicence => 'Permis de conduire';

  @override
  String get docTypeOther => 'Autre';

  @override
  String get detailTitle => 'Détails du document';

  @override
  String get detailFoundIn => 'Trouvé à';

  @override
  String get detailPlace => 'Lieu exact';

  @override
  String get detailDate => 'Date';

  @override
  String get detailNote => 'Remarque';

  @override
  String get detailStatus => 'Statut';

  @override
  String get detailHeldSafely => 'Gardé en sécurité par notre équipe';

  @override
  String get detailPrivacyNote =>
      'Les numéros personnels et la photo sont masqués pour protéger la vie privée. Pour réclamer ce document, répondez à la question de vérification.';

  @override
  String get detailClaimCTA => 'C\'est mon document';

  @override
  String get claimSheetTitle => 'Prouvez votre identité';

  @override
  String get claimSheetSubtitle =>
      'Répondez à la question imprimée sur le document afin que notre équipe puisse vérifier.';

  @override
  String get claimQuestionId => 'Quelle ville a délivré votre carte ?';

  @override
  String get claimQuestionPassport => 'Quelle est votre date de naissance ?';

  @override
  String get claimQuestionBirth => 'Quel est le prénom de votre mère ?';

  @override
  String get claimQuestionOther =>
      'Quelle date est imprimée comme date de délivrance ?';

  @override
  String get claimAnswerPlaceholder => 'Votre réponse';

  @override
  String get claimAddPhoto => 'Ajouter une photo de justificatif (optionnel)';

  @override
  String get claimSubmit => 'Envoyer la réclamation';

  @override
  String get claimCreatedToast =>
      'Réclamation envoyée. Échangez avec l\'équipe ci-dessous.';

  @override
  String get reportTitle => 'Signaler un document trouvé';

  @override
  String get reportStep1Title => 'Prenez une photo du document';

  @override
  String get reportStep1Subtitle =>
      'Cadrez le document dans le viseur. Nous masquerons les données privées avant publication.';

  @override
  String get reportRetake => 'Reprendre la photo';

  @override
  String get reportNext => 'Continuer';

  @override
  String get reportStep2Title => 'Où l\'avez-vous trouvé ?';

  @override
  String get reportTypeLabel => 'Type de document';

  @override
  String get reportTownLabel => 'Ville';

  @override
  String get reportExactPlaceLabel => 'Lieu précis';

  @override
  String get reportExactPlaceHint =>
      'ex. Arrêt de taxi Akwa, près de la boulangerie';

  @override
  String get reportNoteLabel => 'Remarque facultative';

  @override
  String get reportNoteHint =>
      'Tout détail utile sans révéler de données personnelles';

  @override
  String get reportStep3Title => 'Consentement & soumission légale';

  @override
  String get reportConsent1 =>
      'Je consens à la conservation et au traitement de la photo pour identifier le propriétaire (Loi n° 2024/017).';

  @override
  String get reportConsent2 =>
      'Je consens à ce que Doc-Find me contacte par téléphone uniquement pour coordonner la restitution.';

  @override
  String get reportSubmit => 'Soumettre pour examen';

  @override
  String get reportSuccessTitle => 'Merci !';

  @override
  String get reportSuccessSubtitle =>
      'Votre signalement a été reçu. Notre équipe de modération l\'examine actuellement.';

  @override
  String get reportTimelineReceived => 'Signalement reçu';

  @override
  String get reportTimelineReview => 'Examen & masquage';

  @override
  String get reportTimelinePosted => 'Publié avec masquage';

  @override
  String get reportTimelineHandoff => 'Remise au propriétaire';

  @override
  String get reportRecentReports => 'Vos signalements récents';

  @override
  String get reportStatusInReview => 'En examen';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesSupportName => 'Équipe Doc-Find';

  @override
  String get messagesOfficialBadge => 'Support Officiel';

  @override
  String get messagesTypeMessage => 'Écrivez un message...';

  @override
  String get messagesSend => 'Envoyer';

  @override
  String get alertsTitle => 'Alertes de recherche';

  @override
  String get alertsSubtitle =>
      'Nous vous avertissons par Push et SMS dès qu\'un document correspondant est publié.';

  @override
  String get alertsEnabled => 'Push + SMS activés';

  @override
  String get alertsPaused => 'En pause';

  @override
  String get alertsSavedToast => 'Alerte enregistrée pour cette recherche';

  @override
  String get profileTitle => 'Profil & paramètres';

  @override
  String get profileAvatarColor => 'Couleur d\'avatar';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get profileAppearance => 'Apparence';

  @override
  String get profileThemeSystem => 'Système';

  @override
  String get profileThemeLight => 'Clair';

  @override
  String get profileThemeDark => 'Sombre';

  @override
  String get profileDefaultTown => 'Ville par défaut';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profilePush => 'Notifications push';

  @override
  String get profileSms => 'Alertes SMS';

  @override
  String get profileEmail => 'Récapitulatifs par email';

  @override
  String get profilePrivacySecurity => 'Confidentialité & sécurité';

  @override
  String get profileChangePassword => 'Changer le mot de passe';

  @override
  String get profileDownloadData => 'Télécharger mes données';

  @override
  String get profileDeleteAccount => 'Supprimer le compte';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get profileSavedToast => 'Profil mis à jour avec succès';
}
