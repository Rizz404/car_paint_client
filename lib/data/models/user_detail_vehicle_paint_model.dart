/// Model untuk data kendaraan
class VehicleData {
  String brand;
  String model;
  String year;
  String color;

  VehicleData({
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
  });

  @override
  String toString() {
    return "VehicleData(brand: $brand, model: $model, year: $year, color: $color)";
  }
}

/// Model untuk bagian-bagian mobil yang dapat dicat
class PaintableParts {
  bool isFullBodySelected;
  bool isHoodSelected;
  bool isDoorSelected;
  bool isFenderSelected;
  bool isRoofSelected;
  bool isTrunkSelected;
  bool isBumperSelected;
  bool isFrontBumperSelected;

  PaintableParts({
    this.isFullBodySelected = false,
    this.isHoodSelected = false,
    this.isDoorSelected = false,
    this.isFenderSelected = false,
    this.isRoofSelected = false,
    this.isTrunkSelected = false,
    this.isBumperSelected = false,
    this.isFrontBumperSelected = false,
  });
  @override
  String toString() {
    return "PaintableParts(isFullBodySelected: $isFullBodySelected, isHoodSelected: $isHoodSelected, isDoorSelected: $isDoorSelected, isFenderSelected: $isFenderSelected, isRoofSelected: $isRoofSelected, isTrunkSelected: $isTrunkSelected, isBumperSelected: $isBumperSelected, isFrontBumperSelected: $isFrontBumperSelected)";
  }
}

/// Model untuk warna mobil dengan informasi kode dan model yang tersedia
class CarColor {
  final String name;
  final List<String> availableModels;

  CarColor({required this.name, required this.availableModels});
}
