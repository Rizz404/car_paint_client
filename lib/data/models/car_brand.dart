// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarBrand {
  final String? id;
  final String name;
  final String? logo;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CarBrand({
    this.id,
    required this.name,
    this.logo,
    this.country,
    this.createdAt,
    this.updatedAt,
  });

  CarBrand copyWith({
    String? id,
    String? name,
    String? logo,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarBrand(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'logo': logo,
      'country': country,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarBrand.fromMap(Map<String, dynamic> map) {
    return CarBrand(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      logo: map['logo'] != null ? map['logo'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarBrand.fromJson(String source) =>
      CarBrand.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarBrand(id: $id, name: $name, logo: $logo, country: $country, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CarBrand other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.logo == logo &&
        other.country == country &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        logo.hashCode ^
        country.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
