// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserCar {
  final String? id;
  final String userId;
  final String carModelYearColorId;
  final String licensePlate;
  final List<String?>? carImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserCar({
    this.id,
    required this.userId,
    required this.carModelYearColorId,
    required this.licensePlate,
    this.carImages,
    required this.createdAt,
    required this.updatedAt,
  });

  UserCar copyWith({
    String? id,
    String? userId,
    String? carModelYearColorId,
    String? licensePlate,
    List<String>? carImages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserCar(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carModelYearColorId: carModelYearColorId ?? this.carModelYearColorId,
      licensePlate: licensePlate ?? this.licensePlate,
      carImages: carImages ?? this.carImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    };
  }

  factory UserCar.fromMap(Map<String, dynamic> map) {
    return UserCar(
      id: map['id'] as String,
      userId: map['userId'] as String,
      carModelYearColorId: map['carModelYearColorId'] as String,
      licensePlate: map['licensePlate'] as String,
      carImages: (map['carImages'] as List).map((e) => e as String).toList(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCar.fromJson(String source) =>
      UserCar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserCar(id: $id, userId: $userId, carModelYearColorId: $carModelYearColorId, licensePlate: $licensePlate, carImages: $carImages, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        carModelYearColorId.hashCode ^
        licensePlate.hashCode ^
        carImages.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
