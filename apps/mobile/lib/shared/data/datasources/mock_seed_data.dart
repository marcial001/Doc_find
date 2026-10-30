import '../../../core/constants/document_types.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/search_alert.dart';
import '../../domain/entities/user.dart';

abstract final class MockSeedData {
  static const User mockUser = User(
    id: 'user_001',
    name: 'K. N.',
    email: 'demo@docfind.cm',
    phone: '670000000',
    avatarColorHex: '#0E6B47',
    defaultTown: 'Douala',
  );

  static final List<Listing> listings = <Listing>[
    const Listing(
      id: 1,
      type: DocumentType.id,
      name: 'K•••• N••••••',
      town: 'Douala',
      spot: 'Akwa, near Rond-point Deido',
      daysAgo: 0,
      note: 'Found on a taxi seat. Held by finder.',
      question: 'Which town issued your card?',
    ),
    const Listing(
      id: 2,
      type: DocumentType.pass,
      name: 'M•••• T••••',
      town: 'Yaoundé',
      spot: 'Mvan bus park',
      daysAgo: 2,
      note: 'Passport cover is dark blue. Issued 2022.',
      question: 'What is your date of birth?',
    ),
    const Listing(
      id: 3,
      type: DocumentType.birth,
      name: 'E•••• A••••',
      town: 'Bafoussam',
      spot: 'Marché A',
      daysAgo: 5,
      note: 'Folded in a plastic sleeve.',
      question: 'What is your mother\'s first name?',
    ),
    const Listing(
      id: 4,
      type: DocumentType.lic,
      name: 'F•••• B••••',
      town: 'Douala',
      spot: 'Bonabéri ferry quay',
      daysAgo: 9,
      note: 'Category B licence.',
      question: 'Which date is printed as the issue date?',
    ),
    const Listing(
      id: 5,
      type: DocumentType.id,
      name: 'S•••• M••••',
      town: 'Buea',
      spot: 'University of Buea gate',
      daysAgo: 12,
      note: 'Card is slightly bent.',
      question: 'Which town issued your card?',
    ),
    const Listing(
      id: 6,
      type: DocumentType.id,
      name: 'A•••• N••••',
      town: 'Garoua',
      spot: 'Grand Marché',
      daysAgo: 3,
      note: 'Found near the pharmacy stalls.',
      question: 'Which town issued your card?',
    ),
    const Listing(
      id: 7,
      type: DocumentType.birth,
      name: 'J•••• T••••',
      town: 'Bamenda',
      spot: 'Commercial Avenue',
      daysAgo: 20,
      note: 'Photocopy certified, original attached.',
      question: 'What is your mother\'s first name?',
    ),
    const Listing(
      id: 8,
      type: DocumentType.other,
      name: 'Student card · P•••• L••••',
      town: 'Yaoundé',
      spot: 'Ngoa-Ekélé',
      daysAgo: 1,
      note: 'University student card.',
      question: 'Which date is printed as the issue date?',
    ),
  ];

  static final List<ChatThread> threads = <ChatThread>[
    ChatThread(
      id: 0,
      title: 'Doc-Find team',
      subtitle: 'Official Support',
      unreadCount: 1,
      messages: <ChatMessage>[
        ChatMessage(
          id: 'msg_001',
          isFromUser: false,
          text:
              'Welcome to Doc-Find. Ask us anything about finding or returning a document.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ],
    ),
  ];

  static final List<SearchAlert> alerts = <SearchAlert>[
    const SearchAlert(
      id: 'alert_1',
      documentType: DocumentType.id,
      town: 'Douala',
      isEnabled: true,
    ),
    const SearchAlert(
      id: 'alert_2',
      documentType: DocumentType.pass,
      town: 'Any town',
      isEnabled: false,
    ),
  ];
}
