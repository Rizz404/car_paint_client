// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/user_profile_model.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? newAccessToken;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage = "",
    required this.createdAt,
    required this.updatedAt,
    this.newAccessToken,
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
        other.newAccessToken == newAccessToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        newAccessToken.hashCode;
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? newAccessToken,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      newAccessToken: newAccessToken ?? this.newAccessToken,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, profileImage: $profileImage, createdAt: $createdAt, updatedAt: $updatedAt, newAccessToken: $newAccessToken)';
  }
}

class UserWithProfile extends User {
  final UserProfile? userProfile;

  UserWithProfile({
    required String id,
    required String username,
    required String email,
    String profileImage = "",
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
  }) {
    return UserWithProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
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
