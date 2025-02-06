// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarBrand {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  CarBrand({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  CarBrand copyWith({
    String? id,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarBrand(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CarBrand.fromMap(Map<String, dynamic> map) {
    return CarBrand(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CarBrand.fromJson(String source) =>
      CarBrand.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarBrand(id: $id, name: $name, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CarBrand other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
