// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/enums/financial_status.dart';

class PaymentMethod {
  final String? id;
  final String name;
  final String? fee;
  final String? logoUrl;
  final bool? isActive;
  final String? description;
  final String? xenditPaymentMethodId;
  final PaymentMethodType? type;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  PaymentMethod({
    this.id,
    required this.name,
    required this.fee,
    this.createdAt,
    this.updatedAt,
    this.logoUrl,
    this.isActive,
    this.description,
    this.xenditPaymentMethodId,
    this.type,
  });

  PaymentMethod copyWith({
    String? id,
    String? name,
    String? fee,
    String? logoUrl,
    bool? isActive,
    String? description,
    String? xenditPaymentMethodId,
    PaymentMethodType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      fee: fee ?? this.fee,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      xenditPaymentMethodId:
          xenditPaymentMethodId ?? this.xenditPaymentMethodId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'fee': fee,
      'logoUrl': logoUrl,
      'isActive': isActive,
      'description': description,
      'xenditPaymentMethodId': xenditPaymentMethodId,
      'type': type?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      fee: map['fee'] != null ? map['fee'] as String : '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      logoUrl: map['logoUrl'] != null ? map['logoUrl'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      xenditPaymentMethodId: map['xenditPaymentMethodId'] != null
          ? map['xenditPaymentMethodId'] as String
          : null,
      type: map['type'] != null
          ? PaymentMethodTypeExtension.fromMap(map['type'] as String)
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
    return 'PaymentMethod(id: $id, name: $name, fee: $fee, createdAt: $createdAt, updatedAt: $updatedAt, logoUrl: $logoUrl, isActive: $isActive, description: $description, xenditPaymentMethodId: $xenditPaymentMethodId, type: $type)';
  }

  @override
  bool operator ==(covariant PaymentMethod other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.fee == fee &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.logoUrl == logoUrl &&
        other.isActive == isActive &&
        other.description == description &&
        other.xenditPaymentMethodId == xenditPaymentMethodId &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        fee.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        logoUrl.hashCode ^
        isActive.hashCode ^
        description.hashCode ^
        xenditPaymentMethodId.hashCode ^
        type.hashCode;
  }
}
