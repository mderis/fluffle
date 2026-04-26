class User {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? avatarUrl;
  final DateTime? emailVerifiedAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.avatarUrl,
    this.emailVerifiedAt,
  });

  String get displayName => name ?? email;
}
