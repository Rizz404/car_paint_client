class UserProfile {
  final String id;
  final String userId;
  final String? fullname;
  final String? phoneNumber;
  final String? address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    this.fullname,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });
}
