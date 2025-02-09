// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarModel {
  final String? id;
  final String carBrandId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CarModel({
    this.id,
    required this.carBrandId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  CarModel copyWith({
    String? id,
    String? carBrandId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarModel(
      id: id ?? this.id,
      carBrandId: carBrandId ?? this.carBrandId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'carBrandId': carBrandId,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] != null ? map['id'] as String : null,
      carBrandId: map['carBrandId'] as String,
      name: map['name'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModel.fromJson(String source) =>
      CarModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarModel(id: $id, carBrandId: $carBrandId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CarModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.carBrandId == carBrandId &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        carBrandId.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
