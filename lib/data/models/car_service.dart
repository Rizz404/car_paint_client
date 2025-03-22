// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarService {
  final String? id;
  final String name;
  final String price;
  final String? carServiceImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CarService({
    this.id,
    required this.name,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.carServiceImage,
  });

  CarService copyWith({
    String? id,
    String? name,
    String? price,
    String? carServiceImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarService(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      carServiceImage: carServiceImage ?? this.carServiceImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'carServiceImage': carServiceImage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarService.fromMap(Map<String, dynamic> map) {
    return CarService(
      id: map['id']?.toString(),
      name: map['name']?.toString() ?? '',
      price: map['price']?.toString() ?? '0',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'].toString())
          : null,
      carServiceImage: map['carServiceImage']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarService.fromJson(String source) =>
      CarService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarService(id: $id, name: $name, price: $price, createdAt: $createdAt, updatedAt: $updatedAt, carServiceImage: $carServiceImage)';
  }

  @override
  bool operator ==(covariant CarService other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.price == price &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
