// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/data/models/car_model.dart';

class CarModelColor {
  final String? id;
  final String? carModelId;
  final String? colorId;
  final CarModel? carModel;
  final CarColor? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CarModelColor({
    this.id,
    required this.carModelId,
    required this.colorId,
    this.carModel,
    this.color,
    this.createdAt,
    this.updatedAt,
  });
  static empty() {
    return CarModelColor(
      id: '',
      carModelId: '',
      colorId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  CarModelColor copyWith({
    String? id,
    String? carModelId,
    String? colorId,
    CarColor? color,
    CarModel? carModel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarModelColor(
      id: id ?? this.id,
      carModelId: carModelId ?? this.carModelId,
      colorId: colorId ?? this.colorId,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'carModelId': carModelId,
      'colorId': colorId,
      'color': color?.toMap(),
      'carModel': carModel?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarModelColor.fromMap(Map<String, dynamic> map) {
    return CarModelColor(
      id: map['id'] != null ? map['id'] as String : null,
      carModelId:
          map['carModelId'] != null ? map['carModelId'] as String : null,
      carModel: map['carModel'] != null
          ? CarModel.fromMap(map['carModel'] as Map<String, dynamic>)
          : null,
      colorId: map['colorId'] != null ? map['colorId'] as String : null,
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

  factory CarModelColor.fromJson(String source) =>
      CarModelColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarModelColor(id: $id, carModelId: $carModelId, colorId: $colorId, color: $color, carModel: $carModel, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CarModelColor other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.carModelId == carModelId &&
        other.colorId == colorId &&
        other.color == color &&
        other.carModel == carModel &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        carModelId.hashCode ^
        colorId.hashCode ^
        carModel.hashCode ^
        color.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
