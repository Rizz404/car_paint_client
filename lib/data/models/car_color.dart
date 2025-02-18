// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarColor {
  final String? id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CarColor({
    this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  CarColor copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CarColor(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CarColor.fromMap(Map<String, dynamic> map) {
    return CarColor(
      id: map['id'] != null ? map['id'] as String : null,
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

  factory CarColor.fromJson(String source) =>
      CarColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarColor(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CarColor other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
