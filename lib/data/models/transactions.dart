// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/cancellation.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/data/models/payment_detail.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/data/models/refund.dart';

class Transactions {
  final String id;
  final String userId;
  final String paymentMethodId;
  final String adminFee;
  final String totalPrice;
  // final String invoiceId;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentMethod? paymentMethod;
  final Cancellation? cancellation;
  final PaymentDetail? paymentdetail;
  final Refund? refund;
  final List<Orders?>? order;
  Transactions({
    required this.id,
    required this.userId,
    required this.paymentMethodId,
    // required this.invoiceId,
    required this.adminFee,
    required this.totalPrice,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.cancellation,
    this.paymentdetail,
    this.refund,
    this.paymentMethod,
    this.order,
  });

  Transactions copyWith({
    String? id,
    String? userId,
    String? paymentMethodId,
    // String? invoiceId,
    String? adminFee,
    String? totalPrice,
    PaymentStatus? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    PaymentMethod? paymentMethod,
    List<Orders>? order,
    Cancellation? cancellation,
    PaymentDetail? paymentdetail,
    Refund? refund,
  }) {
    return Transactions(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      // invoiceId: invoiceId ?? this.invoiceId,
      adminFee: adminFee ?? this.adminFee,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      order: order ?? this.order,
      cancellation: cancellation ?? this.cancellation,
      paymentdetail: paymentdetail ?? this.paymentdetail,
      refund: refund ?? this.refund,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'paymentMethodId': paymentMethodId,
      // 'invoiceId': invoiceId,
      'adminFee': adminFee,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'paymentMethod': paymentMethod?.toMap(),
      'order': order?.map((x) => x?.toMap()).toList(),
      'cancellation': cancellation?.toMap(),
      'paymentdetail': paymentdetail?.toMap(),
      'refund': refund?.toMap(),
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      paymentMethodId: map['paymentMethodId']?.toString() ?? '',
      // invoiceId: map['invoiceId']?.toString() ?? '',
      adminFee: map['adminFee']?.toString() ?? '0',
      totalPrice: map['totalPrice']?.toString() ?? '0',
      paymentStatus: map['paymentStatus'] != null
          ? PaymentStatusExtension.fromMap(map['paymentStatus'])
          : PaymentStatus.PENDING,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'].toString())
          : DateTime.now(),
      paymentMethod: map['paymentMethod'] != null
          ? PaymentMethod.fromMap(map['paymentMethod'] as Map<String, dynamic>)
          : null,
      order: map['order'] != null
          ? (map['order'] is List
              ? List<Orders>.from(
                  (map['order'] as List).map(
                    (x) => x != null
                        ? Orders.fromMap(x as Map<String, dynamic>)
                        : null,
                  ),
                ).whereType<Orders>().toList()
              : [])
          : null,
      cancellation: map['cancellation'] != null
          ? Cancellation.fromMap(map['cancellation'] as Map<String, dynamic>)
          : null,
      paymentdetail: map['paymentdetail'] != null
          ? PaymentDetail.fromMap(map['paymentdetail'] as Map<String, dynamic>)
          : null,
      refund: map['refund'] != null
          ? Refund.fromMap(map['refund'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transactions(id: $id, userId: $userId, paymentMethodId: $paymentMethodId, adminFee: $adminFee, paymentMethodFee: , totalPrice: $totalPrice, refundAmount: , paymentStatus: $paymentStatus, paymentInvoiceUrl: , refundedAt: , createdAt: $createdAt, updatedAt: $updatedAt, paymentMethod: $paymentMethod, order: $order, cancellation: $cancellation, paymentdetail: $paymentdetail, refund: $refund)';
  }

  @override
  bool operator ==(covariant Transactions other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.paymentMethodId == paymentMethodId &&
        // other.invoiceId == invoiceId &&
        other.adminFee == adminFee &&
        other.totalPrice == totalPrice &&
        other.paymentStatus == paymentStatus &&
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
        // invoiceId.hashCode ^
        adminFee.hashCode ^
        totalPrice.hashCode ^
        paymentStatus.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        paymentMethod.hashCode ^
        order.hashCode;
  }
}
