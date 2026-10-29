import 'package:doc_find/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.normalizePhone', () {
    test('strips +237 country code, spaces and dashes', () {
      expect(Validators.normalizePhone('+237 670 123 456'), '670123456');
      expect(Validators.normalizePhone('237-699-00-11-22'), '699001122');
      expect(Validators.normalizePhone('  +237 650000000 '), '650000000');
    });

    test('leaves local 9-digit number untouched', () {
      expect(Validators.normalizePhone('670123456'), '670123456');
    });
  });

  group('Validators.isValidPhone', () {
    test('accepts valid Cameroon phone numbers', () {
      expect(Validators.isValidPhone('670123456'), isTrue);
      expect(Validators.isValidPhone('+237 699 123 456'), isTrue);
      expect(Validators.isValidPhone('237655443322'), isTrue);
    });

    test('rejects numbers not starting with 6 or wrong length', () {
      expect(Validators.isValidPhone('222123456'), isFalse);
      expect(Validators.isValidPhone('67012345'), isFalse);
      expect(Validators.isValidPhone('6701234567'), isFalse);
      expect(Validators.isValidPhone(null), isFalse);
      expect(Validators.isValidPhone(''), isFalse);
    });
  });

  group('Validators.isValidEmail', () {
    test('accepts valid emails', () {
      expect(Validators.isValidEmail('demo@docfind.cm'), isTrue);
      expect(Validators.isValidEmail('user.name+tag@example.org'), isTrue);
    });

    test('rejects invalid emails', () {
      expect(Validators.isValidEmail('invalid'), isFalse);
      expect(Validators.isValidEmail('user@'), isFalse);
      expect(Validators.isValidEmail('@example.com'), isFalse);
      expect(Validators.isValidEmail(null), isFalse);
    });
  });

  group('Validators.isValidEmailOrPhone', () {
    test('accepts either email or phone', () {
      expect(Validators.isValidEmailOrPhone('demo@docfind.cm'), isTrue);
      expect(Validators.isValidEmailOrPhone('+237 670 000 000'), isTrue);
      expect(Validators.isValidEmailOrPhone('invalid'), isFalse);
    });
  });

  group('Validators.isValidPassword & isRecommendedPassword', () {
    test('validates minimum 6 characters', () {
      expect(Validators.isValidPassword('12345'), isFalse);
      expect(Validators.isValidPassword('123456'), isTrue);
      expect(Validators.isValidPassword('demo1234'), isTrue);
    });

    test('recommends at least 8 characters', () {
      expect(Validators.isRecommendedPassword('123456'), isFalse);
      expect(Validators.isRecommendedPassword('12345678'), isTrue);
    });
  });

  group('Validators.isValidName, isValidPlace, isValidClaimAnswer', () {
    test('name must be >= 2 characters', () {
      expect(Validators.isValidName('A'), isFalse);
      expect(Validators.isValidName('KN'), isTrue);
      expect(Validators.isValidName('K. N.'), isTrue);
    });

    test('place must be >= 3 characters', () {
      expect(Validators.isValidPlace('Ak'), isFalse);
      expect(Validators.isValidPlace('Mvan'), isTrue);
    });

    test('claim answer must be >= 2 characters', () {
      expect(Validators.isValidClaimAnswer('Y'), isFalse);
      expect(Validators.isValidClaimAnswer('Yaoundé'), isTrue);
    });
  });
}
