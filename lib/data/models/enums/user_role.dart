enum UserRole { USER, ADMIN, SUPER_ADMIN }

extension UserRoleExtension on UserRole {
  String toMap() {
    return name;
  }

  static UserRole fromMap(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.USER,
    );
  }
}
