// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Transactions {
  final String id;
  final String userId;
  final String paymentMethodId;
  final String orderId;
  final String adminFee;
  final String paymentMethodFee;
  final String totalPrice;
  final String paymentStatus;
  final String paymentInvoiceUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  Transactions({
    required this.id,
    required this.userId,
    required this.paymentMethodId,
    required this.orderId,
    required this.adminFee,
    required this.paymentMethodFee,
    required this.totalPrice,
    required this.paymentStatus,
    required this.paymentInvoiceUrl,
    this.createdAt,
    this.updatedAt,
  });

  Transactions copyWith({
    String? id,
    String? userId,
    String? paymentMethodId,
    String? orderId,
    String? adminFee,
    String? paymentMethodFee,
    String? totalPrice,
    String? paymentStatus,
    String? paymentInvoiceUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transactions(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      orderId: orderId ?? this.orderId,
      adminFee: adminFee ?? this.adminFee,
      paymentMethodFee: paymentMethodFee ?? this.paymentMethodFee,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentInvoiceUrl: paymentInvoiceUrl ?? this.paymentInvoiceUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'paymentMethodId': paymentMethodId,
      'orderId': orderId,
      'adminFee': adminFee,
      'paymentMethodFee': paymentMethodFee,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'paymentInvoiceUrl': paymentInvoiceUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'] as String,
      userId: map['userId'] as String,
      paymentMethodId: map['paymentMethodId'] as String,
      orderId: map['orderId'] as String,
      adminFee: map['adminFee'] as String,
      paymentMethodFee: map['paymentMethodFee'] as String,
      totalPrice: map['totalPrice'] as String,
      paymentStatus: map['paymentStatus'] as String,
      paymentInvoiceUrl: map['paymentInvoiceUrl'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transactions(id: $id, userId: $userId, paymentMethodId: $paymentMethodId, orderId: $orderId, adminFee: $adminFee, paymentMethodFee: $paymentMethodFee, totalPrice: $totalPrice, paymentStatus: $paymentStatus, paymentInvoiceUrl: $paymentInvoiceUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Transactions other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.paymentMethodId == paymentMethodId &&
        other.orderId == orderId &&
        other.adminFee == adminFee &&
        other.paymentMethodFee == paymentMethodFee &&
        other.totalPrice == totalPrice &&
        other.paymentStatus == paymentStatus &&
        other.paymentInvoiceUrl == paymentInvoiceUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        paymentMethodId.hashCode ^
        orderId.hashCode ^
        adminFee.hashCode ^
        paymentMethodFee.hashCode ^
        totalPrice.hashCode ^
        paymentStatus.hashCode ^
        paymentInvoiceUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
