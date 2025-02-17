// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserProfile {
  final String id;
  final String userId;
  final String? fullname;
  final String? phoneNumber;
  final String? address;
  final String? latitude;
  final String? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    this.fullname,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? id,
    String? userId,
    String? fullname,
    String? phoneNumber,
    String? address,
    String? latitude,
    String? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullname: fullname ?? this.fullname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'fullname': fullname,
      'phoneNumber': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      userId: map['userId'] as String,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserProfile(id: $id, userId: $userId, fullname: $fullname, phoneNumber: $phoneNumber, address: $address, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserProfile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.fullname == fullname &&
        other.phoneNumber == phoneNumber &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        fullname.hashCode ^
        phoneNumber.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
