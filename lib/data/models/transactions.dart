// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/data/models/payment_method.dart';

class Transactions {
  final String id;
  final String userId;
  final String paymentMethodId;
  final String invoiceId;
  final String adminFee;
  final String paymentMethodFee;
  final String totalPrice;
  final String? refundAmount;
  final PaymentStatus paymentStatus;
  final String paymentInvoiceUrl;
  final DateTime? refundedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentMethod? paymentMethod;
  final List<Orders?>? order;
  Transactions({
    required this.id,
    required this.userId,
    required this.paymentMethodId,
    required this.invoiceId,
    required this.adminFee,
    required this.paymentMethodFee,
    required this.totalPrice,
    this.refundAmount,
    required this.paymentStatus,
    required this.paymentInvoiceUrl,
    this.refundedAt,
    required this.createdAt,
    required this.updatedAt,
    this.paymentMethod,
    this.order,
  });

  Transactions copyWith({
    String? id,
    String? userId,
    String? paymentMethodId,
    String? invoiceId,
    String? adminFee,
    String? paymentMethodFee,
    String? totalPrice,
    String? refundAmount,
    PaymentStatus? paymentStatus,
    String? paymentInvoiceUrl,
    DateTime? refundedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    PaymentMethod? paymentMethod,
    List<Orders>? order,
  }) {
    return Transactions(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        paymentMethodId: paymentMethodId ?? this.paymentMethodId,
        invoiceId: invoiceId ?? this.invoiceId,
        adminFee: adminFee ?? this.adminFee,
        paymentMethodFee: paymentMethodFee ?? this.paymentMethodFee,
        totalPrice: totalPrice ?? this.totalPrice,
        refundAmount: refundAmount ?? this.refundAmount,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentInvoiceUrl: paymentInvoiceUrl ?? this.paymentInvoiceUrl,
        refundedAt: refundedAt ?? this.refundedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        order: order ?? this.order);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'paymentMethodId': paymentMethodId,
      'invoiceId': invoiceId,
      'adminFee': adminFee,
      'paymentMethodFee': paymentMethodFee,
      'totalPrice': totalPrice,
      'refundAmount': refundAmount,
      'paymentStatus': paymentStatus.toMap(),
      'paymentInvoiceUrl': paymentInvoiceUrl,
      'refundedAt': refundedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'paymentMethod': paymentMethod?.toMap(),
      'order': order?.map((x) => x?.toMap()).toList(),
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id']?.toString() ??
          '', // Pastikan semua field di-convert ke String
      userId: map['userId']?.toString() ?? '',
      paymentMethodId: map['paymentMethodId']?.toString() ?? '',
      invoiceId: map['invoiceId']?.toString() ?? '',
      adminFee:
          map['adminFee']?.toString() ?? '0', // Handle null, default ke '0'
      paymentMethodFee: map['paymentMethodFee']?.toString() ?? '0',
      totalPrice: map['totalPrice']?.toString() ?? '0',
      refundAmount: map['refundAmount']?.toString(), // auto handle null
      paymentStatus: map['paymentStatus'] != null
          ? PaymentStatusExtension.fromMap(map['paymentStatus'] as String)
          : PaymentStatus.PENDING,
      paymentInvoiceUrl: map['paymentInvoiceUrl']?.toString() ?? '',
      refundedAt: map['refundedAt'] != null
          ? DateTime.parse(map['refundedAt'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      paymentMethod: map['paymentMethod'] != null
          ? PaymentMethod.fromMap(map['paymentMethod'] as Map<String, dynamic>)
          : null,
      order: map['order'] != null
          ? List<Orders?>.from(
              (map['order'] as List).map(
                (x) => x != null
                    ? Orders.fromMap(x as Map<String, dynamic>)
                    : null,
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transactions(id: $id, userId: $userId, paymentMethodId: $paymentMethodId, invoiceId: $invoiceId, adminFee: $adminFee, paymentMethodFee: $paymentMethodFee, totalPrice: $totalPrice, refundAmount: $refundAmount, paymentStatus: $paymentStatus, paymentInvoiceUrl: $paymentInvoiceUrl, refundedAt: $refundedAt, createdAt: $createdAt, updatedAt: $updatedAt, paymentMethod: $paymentMethod, order: $order)';
  }

  @override
  bool operator ==(covariant Transactions other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.paymentMethodId == paymentMethodId &&
        other.invoiceId == invoiceId &&
        other.adminFee == adminFee &&
        other.paymentMethodFee == paymentMethodFee &&
        other.totalPrice == totalPrice &&
        other.refundAmount == refundAmount &&
        other.paymentStatus == paymentStatus &&
        other.paymentInvoiceUrl == paymentInvoiceUrl &&
        other.refundedAt == refundedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.paymentMethod == paymentMethod &&
        other.order == order;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        paymentMethodId.hashCode ^
        invoiceId.hashCode ^
        adminFee.hashCode ^
        paymentMethodFee.hashCode ^
        totalPrice.hashCode ^
        refundAmount.hashCode ^
        paymentStatus.hashCode ^
        paymentInvoiceUrl.hashCode ^
        refundedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        paymentMethod.hashCode ^
        order.hashCode;
  }
}

// ! transactions lama
// class Transactions {
//   final String id;
//   final String userId;
//   final String paymentMethodId;
//   final String orderId;
//   final String adminFee;
//   final String paymentMethodFee;
//   final String totalPrice;
//   final String paymentStatus;
//   final String paymentInvoiceUrl;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   Transactions({
//     required this.id,
//     required this.userId,
//     required this.paymentMethodId,
//     required this.orderId,
//     required this.adminFee,
//     required this.paymentMethodFee,
//     required this.totalPrice,
//     required this.paymentStatus,
//     required this.paymentInvoiceUrl,
//     this.createdAt,
//     this.updatedAt,
//   });

//   Transactions copyWith({
//     String? id,
//     String? userId,
//     String? paymentMethodId,
//     String? orderId,
//     String? adminFee,
//     String? paymentMethodFee,
//     String? totalPrice,
//     String? paymentStatus,
//     String? paymentInvoiceUrl,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return Transactions(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       paymentMethodId: paymentMethodId ?? this.paymentMethodId,
//       orderId: orderId ?? this.orderId,
//       adminFee: adminFee ?? this.adminFee,
//       paymentMethodFee: paymentMethodFee ?? this.paymentMethodFee,
//       totalPrice: totalPrice ?? this.totalPrice,
//       paymentStatus: paymentStatus ?? this.paymentStatus,
//       paymentInvoiceUrl: paymentInvoiceUrl ?? this.paymentInvoiceUrl,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'userId': userId,
//       'paymentMethodId': paymentMethodId,
//       'orderId': orderId,
//       'adminFee': adminFee,
//       'paymentMethodFee': paymentMethodFee,
//       'totalPrice': totalPrice,
//       'paymentStatus': paymentStatus,
//       'paymentInvoiceUrl': paymentInvoiceUrl,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }

//   factory Transactions.fromMap(Map<String, dynamic> map) {
//     return Transactions(
//       id: map['id'] as String,
//       userId: map['userId'] as String,
//       paymentMethodId: map['paymentMethodId'] as String,
//       orderId: map['orderId'] as String,
//       adminFee: map['adminFee'] as String,
//       paymentMethodFee: map['paymentMethodFee'] as String,
//       totalPrice: map['totalPrice'] as String,
//       paymentStatus: map['paymentStatus'] as String,
//       paymentInvoiceUrl: map['paymentInvoiceUrl'] as String,
//       createdAt: map['createdAt'] != null
//           ? DateTime.parse(map['createdAt'] as String)
//           : null,
//       updatedAt: map['updatedAt'] != null
//           ? DateTime.parse(map['updatedAt'] as String)
//           : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Transactions.fromJson(String source) =>
//       Transactions.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'Transactions(id: $id, userId: $userId, paymentMethodId: $paymentMethodId, orderId: $orderId, adminFee: $adminFee, paymentMethodFee: $paymentMethodFee, totalPrice: $totalPrice, paymentStatus: $paymentStatus, paymentInvoiceUrl: $paymentInvoiceUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
//   }

//   @override
//   bool operator ==(covariant Transactions other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         other.userId == userId &&
//         other.paymentMethodId == paymentMethodId &&
//         other.orderId == orderId &&
//         other.adminFee == adminFee &&
//         other.paymentMethodFee == paymentMethodFee &&
//         other.totalPrice == totalPrice &&
//         other.paymentStatus == paymentStatus &&
//         other.paymentInvoiceUrl == paymentInvoiceUrl &&
//         other.createdAt == createdAt &&
//         other.updatedAt == updatedAt;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         userId.hashCode ^
//         paymentMethodId.hashCode ^
//         orderId.hashCode ^
//         adminFee.hashCode ^
//         paymentMethodFee.hashCode ^
//         totalPrice.hashCode ^
//         paymentStatus.hashCode ^
//         paymentInvoiceUrl.hashCode ^
//         createdAt.hashCode ^
//         updatedAt.hashCode;
//   }
// }
