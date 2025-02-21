// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:paint_car/data/models/orders.dart';

class ETicket {
  final String? id;
  final String? userId;
  final String? orderId;
  final int ticketNumber;
  final Orders? order;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  ETicket({
    this.id,
    required this.userId,
    required this.orderId,
    required this.ticketNumber,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  ETicket copyWith({
    String? id,
    String? userId,
    String? orderId,
    int? ticketNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ETicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      order: order ?? this.order,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'orderId': orderId,
      'ticketNumber': ticketNumber,
      'order': order,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ETicket.fromMap(Map<String, dynamic> map) {
    return ETicket(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      ticketNumber: map['ticketNumber'] as int,
      // order: map['order'] != null
      //     ? Orders.fromMap(map['order'] as Map<String, dynamic>)
      //     : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ETicket.fromJson(String source) =>
      ETicket.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ETicket(id: $id, userId: $userId, orderId: $orderId, ticketNumber: $ticketNumber, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ETicket other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.orderId == orderId &&
        other.ticketNumber == ticketNumber &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        orderId.hashCode ^
        ticketNumber.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
