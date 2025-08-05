class User {
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final bool isActive;
  final String token;

  User({
    required this.roles,
    required this.isActive,
    required this.token,
    required this.id,
    required this.email,
    required this.fullName,
  });

  bool get isAdmin => roles.contains('admin');
}
