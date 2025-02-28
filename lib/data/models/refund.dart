// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Refund {
  final String? id;
  final String? transactionId;
  final String? amount;
  final String? reason;
  final String? refundedById;
  final DateTime? refundedAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  Refund({
    this.id,
    this.transactionId,
    this.amount,
    this.reason,
    this.refundedById,
    this.refundedAt,
    this.createdAt,
    this.updatedAt,
  });

  Refund copyWith({
    String? id,
    String? transactionId,
    String? amount,
    String? reason,
    String? refundedById,
    DateTime? refundedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Refund(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      refundedById: refundedById ?? this.refundedById,
      refundedAt: refundedAt ?? this.refundedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transactionId': transactionId,
      'amount': amount,
      'reason': reason,
      'refundedById': refundedById,
      'refundedAt': refundedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Refund.fromMap(Map<String, dynamic> map) {
    return Refund(
      id: map['id'] != null ? map['id'] as String : null,
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      refundedById:
          map['refundedById'] != null ? map['refundedById'] as String : null,
      refundedAt: map['refundedAt'] != null
          ? DateTime.parse(map['refundedAt'] as String)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Refund.fromJson(String source) =>
      Refund.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Refund(id: $id, transactionId: $transactionId, amount: $amount, reason: $reason, refundedById: $refundedById, refundedAt: $refundedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Refund other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.transactionId == transactionId &&
        other.amount == amount &&
        other.reason == reason &&
        other.refundedById == refundedById &&
        other.refundedAt == refundedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        transactionId.hashCode ^
        amount.hashCode ^
        reason.hashCode ^
        refundedById.hashCode ^
        refundedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
