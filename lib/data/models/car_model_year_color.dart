// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/data/models/car_model_years.dart';

class CarModelYearColor {
  final String? id;
  final String carModelYearId;
  final String colorId;
  final CarModelYears? carModelYear;
  final CarColor? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CarModelYearColor({
    this.id,
    required this.carModelYearId,
    required this.colorId,
    this.carModelYear,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  CarModelYearColor copyWith({
    String? id,
    String? carModelYearId,
    String? colorId,
    CarModelYears? carModelYear,
    CarColor? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarModelYearColor(
      id: id ?? this.id,
      carModelYearId: carModelYearId ?? this.carModelYearId,
      colorId: colorId ?? this.colorId,
      carModelYear: carModelYear ?? this.carModelYear,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'carModelYearId': carModelYearId,
      'colorId': colorId,
      'carModelYear': carModelYear?.toMap(),
      'color': color?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarModelYearColor.fromMap(Map<String, dynamic> map) {
    return CarModelYearColor(
      id: map['id'] != null ? map['id'] as String : null,
      carModelYearId: map['carModelYearId'] as String,
      colorId: map['colorId'] as String,
      carModelYear: map['carModelYear'] != null
          ? CarModelYears.fromMap(map['carModelYear'] as Map<String, dynamic>)
          : null,
      color: map['color'] != null
          ? CarColor.fromMap(map['color'] as Map<String, dynamic>)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModelYearColor.fromJson(String source) =>
      CarModelYearColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarModelYearColor(id: $id, carModelYearId: $carModelYearId, colorId: $colorId, carModelYear: $carModelYear, color: $color, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CarModelYearColor other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.carModelYearId == carModelYearId &&
        other.colorId == colorId &&
        other.carModelYear == carModelYear &&
        other.color == color &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        carModelYearId.hashCode ^
        colorId.hashCode ^
        carModelYear.hashCode ^
        color.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
