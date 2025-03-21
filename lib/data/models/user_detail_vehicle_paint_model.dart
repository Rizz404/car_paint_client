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

  final String fullBodyId = "full_body";
  final String hoodId = "hood";
  final String doorId = "door";
  final String fenderId = "fender";
  final String roofId = "roof";
  final String trunkId = "trunk";
  final String bumperId = "bumper";
  final String frontBumperId = "front_bumper";

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

  List<String> getSelectedPartsIds() {
    List<String> selectedParts = [];

    if (isFullBodySelected) {
      selectedParts.add(fullBodyId);
    } else {
      if (isHoodSelected) selectedParts.add(hoodId);
      if (isDoorSelected) selectedParts.add(doorId);
      if (isFenderSelected) selectedParts.add(fenderId);
      if (isRoofSelected) selectedParts.add(roofId);
      if (isTrunkSelected) selectedParts.add(trunkId);
      if (isBumperSelected) selectedParts.add(bumperId);
      if (isFrontBumperSelected) selectedParts.add(frontBumperId);
    }

    return selectedParts;
  }

  bool get areAllPartsSelected =>
      isHoodSelected &&
      isDoorSelected &&
      isFenderSelected &&
      isRoofSelected &&
      isBumperSelected &&
      isFrontBumperSelected;

  void selectAllParts(bool value) {
    isHoodSelected = value;
    isDoorSelected = value;
    isFenderSelected = value;
    isRoofSelected = value;
    isTrunkSelected = value;
    isBumperSelected = value;
    isFrontBumperSelected = value;
  }

  @override
  String toString() {
    return "PaintableParts(isFullBodySelected: $isFullBodySelected, "
        "isHoodSelected: $isHoodSelected, "
        "isDoorSelected: $isDoorSelected, "
        "isFenderSelected: $isFenderSelected, "
        "isRoofSelected: $isRoofSelected, "
        "isTrunkSelected: $isTrunkSelected, "
        "isBumperSelected: $isBumperSelected, "
        "isFrontBumperSelected: $isFrontBumperSelected)";
  }
}
