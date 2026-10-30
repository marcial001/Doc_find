class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarColorHex = '#0E6B47',
    this.defaultTown = 'Douala',
    this.language = 'en',
    this.themeMode = 'system',
    this.pushNotifications = true,
    this.smsNotifications = true,
    this.emailNotifications = false,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarColorHex;
  final String defaultTown;
  final String language;
  final String themeMode;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool emailNotifications;

  String get initials {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'DF';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarColorHex,
    String? defaultTown,
    String? language,
    String? themeMode,
    bool? pushNotifications,
    bool? smsNotifications,
    bool? emailNotifications,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarColorHex: avatarColorHex ?? this.avatarColorHex,
      defaultTown: defaultTown ?? this.defaultTown,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == id &&
          other.name == name &&
          other.email == email &&
          other.phone == phone &&
          other.avatarColorHex == avatarColorHex &&
          other.defaultTown == defaultTown &&
          other.language == language &&
          other.themeMode == themeMode &&
          other.pushNotifications == pushNotifications &&
          other.smsNotifications == smsNotifications &&
          other.emailNotifications == emailNotifications);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    phone,
    avatarColorHex,
    defaultTown,
    language,
    themeMode,
    pushNotifications,
    smsNotifications,
    emailNotifications,
  );
}
