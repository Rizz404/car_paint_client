import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';

class VehicleDataLocal {
  final SharedPreferences _prefs;
  static const String _vehicleDataKey = 'vehicle_data';

  VehicleDataLocal(this._prefs);

  Future<void> saveVehicleData(VehicleData vehicleData) async {
    final vehicleDataJson = {
      'carBrand': vehicleData.carBrand,
      'carBrandId': vehicleData.carBrandId,
      'carColor': vehicleData.carColor,
      'carColorId': vehicleData.carColorId,
      'carModel': vehicleData.carModel,
      'carModelId': vehicleData.carModelId,
      'carModelYear': vehicleData.carModelYear,
      'carModelYearId': vehicleData.carModelYearId,
      'carModelYearColor': vehicleData.carModelYearColor,
      'carModelYearColorId': vehicleData.carModelYearColorId,
    };
    await _prefs.setString(_vehicleDataKey, jsonEncode(vehicleDataJson));
  }

  VehicleData? getVehicleData() {
    final vehicleDataString = _prefs.getString(_vehicleDataKey);
    if (vehicleDataString == null || vehicleDataString.isEmpty) {
      return null;
    }

    try {
      final vehicleDataJson =
          jsonDecode(vehicleDataString) as Map<String, dynamic>;
      return VehicleData(
        carBrand: vehicleDataJson['carBrand'] as String?,
        carBrandId: vehicleDataJson['carBrandId'] as String?,
        carColor: vehicleDataJson['carColor'] as String?,
        carColorId: vehicleDataJson['carColorId'] as String?,
        carModel: vehicleDataJson['carModel'] as String?,
        carModelId: vehicleDataJson['carModelId'] as String?,
        carModelYear: vehicleDataJson['carModelYear'] as String?,
        carModelYearId: vehicleDataJson['carModelYearId'] as String?,
        carModelYearColor: vehicleDataJson['carModelYearColor'] as String?,
        carModelYearColorId: vehicleDataJson['carModelYearColorId'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> clearVehicleData() async {
    await _prefs.remove(_vehicleDataKey);
  }
}
