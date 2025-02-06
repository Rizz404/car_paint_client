class UserCar {
  final String id;
  final String userId;
  final String carBrandId;
  final String carModelId;
  final String carModelColorId;
  final String carModelYearId;
  final String licensePlate;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserCar({
    required this.id,
    required this.userId,
    required this.carBrandId,
    required this.carModelId,
    required this.carModelColorId,
    required this.carModelYearId,
    required this.licensePlate,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
  });
}
