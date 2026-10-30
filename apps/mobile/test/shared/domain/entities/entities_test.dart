import 'package:doc_find/core/constants/document_types.dart';
import 'package:doc_find/shared/domain/entities/listing.dart';
import 'package:doc_find/shared/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User entity', () {
    test('initials generates correct initials for single and multi-word names', () {
      const User user1 = User(
        id: '1',
        name: 'John Doe',
        email: 'j@d.cm',
        phone: '670000000',
      );
      expect(user1.initials, 'JD');

      const User user2 = User(
        id: '2',
        name: 'Single',
        email: 's@d.cm',
        phone: '670000000',
      );
      expect(user2.initials, 'S');

      const User user3 = User(
        id: '3',
        name: '',
        email: 'e@d.cm',
        phone: '670000000',
      );
      expect(user3.initials, 'DF');
    });

    test('copyWith updates fields correctly and maintains equality', () {
      const User user = User(
        id: '1',
        name: 'Name',
        email: 'email@cm.cm',
        phone: '670000000',
      );

      final User copy = user.copyWith(name: 'New Name');
      expect(copy.name, 'New Name');
      expect(copy.email, 'email@cm.cm');

      final User identicalCopy = user.copyWith();
      expect(identicalCopy, equals(user));
      expect(identicalCopy.hashCode, equals(user.hashCode));
    });
  });

  group('Listing entity', () {
    test('Listing properties, copyWith, equality and hashCode', () {
      const Listing listing = Listing(
        id: 1,
        type: DocumentType.id,
        name: 'Name',
        town: 'Douala',
        spot: 'Akwa',
        daysAgo: 2,
        note: 'Note',
        question: 'Question',
      );

      expect(listing.id, 1);
      expect(listing.type, DocumentType.id);

      final Listing copy = listing.copyWith(town: 'Yaoundé');
      expect(copy.town, 'Yaoundé');
      expect(copy.spot, 'Akwa');

      final Listing identicalListing = listing.copyWith();
      expect(identicalListing, equals(listing));
      expect(identicalListing.hashCode, equals(listing.hashCode));
    });
  });
}
