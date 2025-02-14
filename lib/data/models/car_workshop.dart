// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarWorkshop {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String? distance;
  final double latitude;
  final double longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CarWorkshop({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distance,
    this.createdAt,
    this.updatedAt,
  });

  CarWorkshop copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? distance,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarWorkshop(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'distance': distance,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarWorkshop.fromMap(Map<String, dynamic> map) {
    return CarWorkshop(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phone_number'] as String, // gunakan key yang sesuai
      address: map['address'] as String,
      distance: map['distance'] != null ? map['distance'] as String : null,
      latitude: double.parse(map['latitude'] as String),
      longitude: double.parse(map['longitude'] as String),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarWorkshop.fromJson(String source) =>
      CarWorkshop.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarWorkshop(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, address: $address, latitude: $latitude, distance: $distance, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CarWorkshop other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.distance == distance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        distance.hashCode;
  }
}
