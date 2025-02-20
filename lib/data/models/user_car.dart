// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';

class UserCar {
  final String? id;
  final String? userId;
  final String carModelYearColorId;
  final String licensePlate;
  final List<String?>? carImages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CarModelYearColor? carModelYearColor;

  UserCar({
    this.id,
    this.userId,
    required this.carModelYearColorId,
    required this.licensePlate,
    this.carImages,
    required this.createdAt,
    required this.updatedAt,
    this.carModelYearColor,
  });

  UserCar copyWith({
    String? id,
    String? userId,
    String? carModelYearColorId,
    String? licensePlate,
    List<String>? carImages,
    DateTime? createdAt,
    DateTime? updatedAt,
    CarModelYearColor? carModelYearColor,
  }) {
    return UserCar(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carModelYearColorId: carModelYearColorId ?? this.carModelYearColorId,
      licensePlate: licensePlate ?? this.licensePlate,
      carImages: carImages ?? this.carImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      carModelYearColor: carModelYearColor ?? this.carModelYearColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'carModelYearColorId': carModelYearColorId,
      'licensePlate': licensePlate,
      'carImages': carImages,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'carModelYearColor': carModelYearColor?.toMap(),
    };
  }

  factory UserCar.fromMap(Map<String, dynamic> map) {
    return UserCar(
      id: map['id'] as String?,
      userId: map['userId'] as String?,
      carModelYearColorId: map['carModelYearColorId'] as String? ?? '',
      licensePlate: map['licensePlate'] as String? ?? '',
      carImages:
          (map['carImages'] as List?)?.map((e) => e as String).toList() ?? [],
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      carModelYearColor: map['carModelYearColor'] == null
          ? null
          : CarModelYearColor.fromMap(
              map['carModelYearColor'] as Map<String, dynamic>,
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCar.fromJson(String source) =>
      UserCar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserCar(id: $id, userId: $userId, carModelYearColorId: $carModelYearColorId, licensePlate: $licensePlate, carImages: $carImages, createdAt: $createdAt, updatedAt: $updatedAt, carModelYearColor: $carModelYearColor)';
  }

  @override
  bool operator ==(covariant UserCar other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.carModelYearColorId == carModelYearColorId &&
        other.licensePlate == licensePlate &&
        listEquals(other.carImages, carImages) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.carModelYearColor == carModelYearColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        carModelYearColorId.hashCode ^
        licensePlate.hashCode ^
        carImages.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        carModelYearColor.hashCode;
  }
}
