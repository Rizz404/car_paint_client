class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.profileImage = "",
    required this.createdAt,
    required this.updatedAt,
  });
}
