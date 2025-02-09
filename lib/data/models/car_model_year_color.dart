// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/car_colors.dart';
import 'package:paint_car/data/models/car_model_years.dart';

class CarModelYearColor {
  final String? id;
  final String carModelYearId;
  final String colorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CarModelYears carModelYear;
  final CarColors color;
  CarModelYearColor({
    this.id,
    required this.carModelYearId,
    required this.colorId,
    this.createdAt,
    this.updatedAt,
    required this.carModelYear,
    required this.color,
  });

  CarModelYearColor copyWith({
    String? id,
    String? carModelYearId,
    String? colorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    CarModelYears? carModelYear,
    CarColors? color,
  }) {
    return CarModelYearColor(
      id: id ?? this.id,
      carModelYearId: carModelYearId ?? this.carModelYearId,
      colorId: colorId ?? this.colorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      carModelYear: carModelYear ?? this.carModelYear,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'carModelYearId': carModelYearId,
      'colorId': colorId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'carModelYear': carModelYear.toMap(),
      'color': color.toMap(),
    };
  }

  factory CarModelYearColor.fromMap(Map<String, dynamic> map) {
    return CarModelYearColor(
      id: map['id'] != null ? map['id'] as String : null,
      carModelYearId: map['carModelYearId'] as String,
      colorId: map['colorId'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      carModelYear:
          CarModelYears.fromMap(map['carModelYear'] as Map<String, dynamic>),
      color: CarColors.fromMap(map['color'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModelYearColor.fromJson(String source) =>
      CarModelYearColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarModelYearColor(id: $id, carModelYearId: $carModelYearId, colorId: $colorId, createdAt: $createdAt, updatedAt: $updatedAt, carModelYear: $carModelYear, color: $color)';
  }

  @override
  bool operator ==(covariant CarModelYearColor other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.carModelYearId == carModelYearId &&
        other.colorId == colorId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.carModelYear == carModelYear &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        carModelYearId.hashCode ^
        colorId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        carModelYear.hashCode ^
        color.hashCode;
  }
}
