// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/models/user_profile_model.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? newAccessToken;
  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage = "",
    required this.createdAt,
    required this.updatedAt,
    this.newAccessToken,
    required this.role,
  });

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.newAccessToken == newAccessToken &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        newAccessToken.hashCode ^
        role.hashCode;
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? newAccessToken,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      newAccessToken: newAccessToken ?? this.newAccessToken,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'newAccessToken': newAccessToken,
      'role': role.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      newAccessToken: map['newAccessToken'] != null
          ? map['newAccessToken'] as String
          : null,
      role: UserRoleExtension.fromMap(map['role'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, profileImage: $profileImage, createdAt: $createdAt, updatedAt: $updatedAt, newAccessToken: $newAccessToken, role: $role)';
  }
}

class UserWithProfile extends User {
  final UserProfile? userProfile;

  UserWithProfile({
    required String id,
    required String username,
    required String email,
    String profileImage = "",
    required UserRole role,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? newAccessToken,
    this.userProfile,
  }) : super(
          id: id,
          username: username,
          email: email,
          profileImage: profileImage,
          createdAt: createdAt,
          updatedAt: updatedAt,
          newAccessToken: newAccessToken,
          role: role,
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! UserWithProfile) return false;
    return super == other && other.userProfile == userProfile;
  }

  @override
  int get hashCode => super.hashCode ^ userProfile.hashCode;

  UserWithProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? newAccessToken,
    UserProfile? userProfile,
    UserRole? role,
  }) {
    return UserWithProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      newAccessToken: newAccessToken ?? this.newAccessToken,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['userProfile'] = userProfile?.toMap();
    return map;
  }

  factory UserWithProfile.fromMap(Map<String, dynamic> map) {
    return UserWithProfile(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      newAccessToken: map['newAccessToken'] != null
          ? map['newAccessToken'] as String
          : null,
      userProfile: map['userProfile'] != null
          ? UserProfile.fromMap(map['userProfile'] as Map<String, dynamic>)
          : null,
      role: UserRoleExtension.fromMap(map['role'] as String),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserWithProfile.fromJson(String source) =>
      UserWithProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserWithProfile(${super.toString()}, userProfile: $userProfile)';
  }
}
