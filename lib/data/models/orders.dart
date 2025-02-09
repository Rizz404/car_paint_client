// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/enums/financial_status.dart';

class Orders {
  final String? id;
  final String userId;
  final String userCarId;
  final String workshopId;
  final WorkStatus workStatus;
  final OrderStatus orderStatus;
  final String note;
  final String totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  Orders({
    this.id,
    required this.userId,
    required this.userCarId,
    required this.workshopId,
    required this.workStatus,
    required this.orderStatus,
    required this.note,
    required this.totalPrice,
    this.createdAt,
    this.updatedAt,
  });

  Orders copyWith({
    String? id,
    String? userId,
    String? userCarId,
    String? workshopId,
    WorkStatus? workStatus,
    OrderStatus? orderStatus,
    String? note,
    String? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Orders(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userCarId: userCarId ?? this.userCarId,
      workshopId: workshopId ?? this.workshopId,
      workStatus: workStatus ?? this.workStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      note: note ?? this.note,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'userCarId': userCarId,
      'workshopId': workshopId,
      'workStatus': workStatus.toMap(),
      'orderStatus': orderStatus.toMap(),
      'note': note,
      'totalPrice': totalPrice,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] as String,
      userCarId: map['userCarId'] as String,
      workshopId: map['workshopId'] as String,
      workStatus: WorkStatusExtension.fromMap(map['workStatus'] as String),
      orderStatus: OrderStatusExtension.fromMap(map['orderStatus'] as String),
      note: map['note'] as String,
      totalPrice: map['totalPrice'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Orders.fromJson(String source) =>
      Orders.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Orders(id: $id, userId: $userId, userCarId: $userCarId, workshopId: $workshopId, workStatus: $workStatus, orderStatus: $orderStatus, note: $note, totalPrice: $totalPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Orders other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.userCarId == userCarId &&
        other.workshopId == workshopId &&
        other.workStatus == workStatus &&
        other.orderStatus == orderStatus &&
        other.note == note &&
        other.totalPrice == totalPrice &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        userCarId.hashCode ^
        workshopId.hashCode ^
        workStatus.hashCode ^
        orderStatus.hashCode ^
        note.hashCode ^
        totalPrice.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
