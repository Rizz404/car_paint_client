// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/car_model.dart';

class CarModelYears {
  final String? id;
  final String? carModelId;
  final int year;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CarModel? carModel;
  CarModelYears({
    this.id,
    required this.carModelId,
    required this.year,
    this.createdAt,
    this.updatedAt,
    required this.carModel,
  });

  CarModelYears copyWith({
    String? id,
    String? carModelId,
    int? year,
    DateTime? createdAt,
    DateTime? updatedAt,
    CarModel? carModel,
  }) {
    return CarModelYears(
      id: id ?? this.id,
      carModelId: carModelId ?? this.carModelId,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      carModel: carModel ?? this.carModel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'carModelId': carModelId,
      'year': year,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'carModel': carModel?.toMap(),
    };
  }

  factory CarModelYears.fromMap(Map<String, dynamic> map) {
    return CarModelYears(
      id: map['id'] != null ? map['id'] as String : null,
      carModelId:
          map['carModelId'] != null ? map['carModelId'] as String : null,
      year: map['year'] as int,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      carModel: map['carModel'] != null
          ? CarModel.fromMap(map['carModel'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModelYears.fromJson(String source) =>
      CarModelYears.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarModelYears(id: $id, carModelId: $carModelId, year: $year, createdAt: $createdAt, updatedAt: $updatedAt, carModel: $carModel)';
  }

  @override
  bool operator ==(covariant CarModelYears other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.carModelId == carModelId &&
        other.year == year &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.carModel == carModel;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        carModelId.hashCode ^
        year.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        carModel.hashCode;
  }
}
