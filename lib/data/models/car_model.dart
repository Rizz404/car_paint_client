// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/car_brand.dart';

class CarModel {
  final String? id;
  final String? carBrandId;
  final String name;
  final CarBrand? carBrand;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CarModel({
    this.id,
    required this.carBrandId,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.carBrand,
  });

  CarModel copyWith({
    String? id,
    String? carBrandId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    CarBrand? carBrand,
  }) {
    return CarModel(
      id: id ?? this.id,
      carBrandId: carBrandId ?? this.carBrandId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      carBrand: carBrand ?? this.carBrand,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'carBrandId': carBrandId,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'carBrand': carBrand?.toMap(),
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] != null ? map['id'] as String : null,
      carBrandId:
          map['carBrandId'] != null ? map['carBrandId'] as String : null,
      name: map['name'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      carBrand: map['carBrand'] != null
          ? CarBrand.fromMap(map['carBrand'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModel.fromJson(String source) =>
      CarModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarModel(id: $id, carBrandId: $carBrandId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, carBrand: $carBrand)';
  }

  @override
  bool operator ==(covariant CarModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.carBrandId == carBrandId &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.carBrand == carBrand;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        carBrandId.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        carBrand.hashCode;
  }
}
