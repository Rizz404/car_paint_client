// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderNotification {
  final OrderEventType? type;
  final String? orderId;
  final String? userId;
  final String? workshopId;
  final String? message;
  final DateTime? timestamp;
  final dynamic data;
  final bool? isRead;

  OrderNotification({
    this.type,
    this.orderId,
    this.userId,
    this.workshopId,
    this.message,
    this.timestamp,
    this.data,
    this.isRead = false,
  });

  OrderNotification copyWith({
    OrderEventType? type,
    String? orderId,
    String? userId,
    String? workshopId,
    String? message,
    DateTime? timestamp,
    dynamic data,
    bool? isRead,
  }) {
    return OrderNotification(
      type: type ?? this.type,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      workshopId: workshopId ?? this.workshopId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type?.toMap(),
      'orderId': orderId,
      'userId': userId,
      'workshopId': workshopId,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
      'data': data,
      'isRead': isRead,
    };
  }

  factory OrderNotification.fromMap(Map<String, dynamic>? map) {
    if (map == null) return OrderNotification();
    return OrderNotification(
      type: map['type'] != null
          ? OrderEventTypeExtension.fromMap(map['type'])
          : null,
      orderId: map['orderId'] as String?,
      userId: map['userId'] as String?,
      workshopId: map['workshopId'] as String?,
      message: map['message'] as String?,
      timestamp:
          map['timestamp'] != null ? DateTime.tryParse(map['timestamp']) : null,
      data: map['data'],
      isRead: map['isRead'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderNotification.fromJson(String source) =>
      OrderNotification.fromMap(json.decode(source) as Map<String, dynamic>?);

  @override
  String toString() {
    return 'OrderNotification(type: $type, orderId: $orderId, userId: $userId, workshopId: $workshopId, message: $message, timestamp: $timestamp, data: $data, isRead: $isRead)';
  }
}

enum OrderEventType {
  created,
  updated,
  cancelled,
  completed,
  started,
  payment;
}

const Map<OrderEventType, String> orderEventTypeDescriptions = {
  OrderEventType.created: 'order:created',
  OrderEventType.updated: 'order:updated',
  OrderEventType.cancelled: 'order:cancelled',
  OrderEventType.completed: 'order:completed',
  OrderEventType.started: 'order:started',
  OrderEventType.payment: 'order:payment:completed',
};

extension OrderEventTypeExtension on OrderEventType {
  String toMap() {
    return name;
  }

  static OrderEventType? fromMap(String? status) {
    if (status == null) return null;
    return OrderEventType.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderEventType.created,
    );
  }
}
