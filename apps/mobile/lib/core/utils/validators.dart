abstract final class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
  );

  /// Strips spaces, dashes, `+`, and Cameroon prefix `237`.
  static String normalizePhone(String raw) {
    String cleaned = raw.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    if (cleaned.startsWith('237')) {
      cleaned = cleaned.substring(3);
    }
    return cleaned;
  }

  /// Cameroon phone number validation: 9 digits starting with 6.
  static bool isValidPhone(String? input) {
    if (input == null || input.trim().isEmpty) return false;
    final String normalized = normalizePhone(input);
    return normalized.length == 9 &&
        normalized.startsWith('6') &&
        RegExp(r'^[0-9]+$').hasMatch(normalized);
  }

  /// Standard email validation.
  static bool isValidEmail(String? input) {
    if (input == null || input.trim().isEmpty) return false;
    return _emailRegex.hasMatch(input.trim());
  }

  /// Validates either an email or a phone number.
  static bool isValidEmailOrPhone(String? input) {
    if (input == null || input.trim().isEmpty) return false;
    final String trimmed = input.trim();
    if (trimmed.contains('@')) {
      return isValidEmail(trimmed);
    }
    return isValidPhone(trimmed);
  }

  /// Password must be at least 6 characters.
  static bool isValidPassword(String? input) {
    if (input == null) return false;
    return input.length >= 6;
  }

  /// Recommended password length is >= 8 characters.
  static bool isRecommendedPassword(String? input) {
    if (input == null) return false;
    return input.length >= 8;
  }

  /// Name must be at least 2 characters.
  static bool isValidName(String? input) {
    if (input == null) return false;
    return input.trim().length >= 2;
  }

  /// Exact place description must be at least 3 characters.
  static bool isValidPlace(String? input) {
    if (input == null) return false;
    return input.trim().length >= 3;
  }

  /// Claim proof answer must be at least 2 characters.
  static bool isValidClaimAnswer(String? input) {
    if (input == null) return false;
    return input.trim().length >= 2;
  }
}
