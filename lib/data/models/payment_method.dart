// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentMethod {
  final String? id;
  final String name;
  final String fee;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  PaymentMethod({
    this.id,
    required this.name,
    required this.fee,
    this.createdAt,
    this.updatedAt,
  });

  PaymentMethod copyWith({
    String? id,
    String? name,
    String? fee,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      fee: fee ?? this.fee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'fee': fee,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      fee: map['fee'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentMethod(id: $id, name: $name, fee: $fee, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PaymentMethod other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.fee == fee &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        fee.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
