// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarService {
  final String? id;
  final String name;
  final String price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CarService({
    this.id,
    required this.name,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  CarService copyWith({
    String? id,
    String? name,
    String? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarService(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarService.fromMap(Map<String, dynamic> map) {
    return CarService(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      price: map['price'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarService.fromJson(String source) =>
      CarService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarService(id: $id, name: $name, price: $price, createdAt: $createdAt, updatedAt: $updatedAt)';
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
