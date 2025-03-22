// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/enums/payment_reusability.dart';

class PaymentMethod {
  final String? id;
  final String name;
  final PaymentMethodType? type;
  final PaymentReusability? reusability;
  final String? fee;
  final String? logoUrl;
  final bool? isActive;
  final String? description;

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
    this.type,
    this.reusability,
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
    PaymentReusability? reusability,
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
      type: type ?? this.type,
      reusability: reusability ?? this.reusability,
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
      'paymentMethodType': type?.toMap(),
      'paymentReusability': reusability?.toMap(),
      'type': type?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id']?.toString(),
      name: map['name']?.toString() ?? '',
      fee: map['fee']?.toString() ?? '0',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : null,
      logoUrl: map['logoUrl']?.toString(),
      isActive: map['isActive'] as bool?,
      description: map['description']?.toString(),
      type: map['type'] != null
          ? PaymentMethodTypeExtension.fromMap(map['type'].toString())
          : null,
      reusability: map['reusability'] != null
          ? PaymentReusabilityExtension.fromMap(map['reusability'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentMethod(id: $id, name: $name, fee: $fee, createdAt: $createdAt, updatedAt: $updatedAt, logoUrl: $logoUrl, isActive: $isActive, description: $description, xenditPaymentMethodId: , type: $type, reusability: $reusability)';
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
        type.hashCode;
  }
}
