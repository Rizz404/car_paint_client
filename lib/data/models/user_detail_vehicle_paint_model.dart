/// Model untuk data kendaraan
class VehicleData {
  String? carModelYearColor;
  String? carBrand;
  String? carColor;
  String? carModel;
  String? carModelYear;
  String? carModelYearColorId;
  String? carBrandId;
  String? carColorId;
  String? carModelId;
  String? carModelYearId;

  VehicleData({
    this.carModelYearColor,
    this.carBrand,
    this.carColor,
    this.carModel,
    this.carModelYear,
    this.carModelYearColorId,
    this.carBrandId,
    this.carColorId,
    this.carModelId,
    this.carModelYearId,
  });
}

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
