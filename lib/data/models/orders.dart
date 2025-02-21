// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/data/models/e_ticket.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';

class Orders {
  final String? id;
  final String? userId;
  final String? userCarId;
  final String? workshopId;
  final WorkStatus? workStatus;
  final OrderStatus? orderStatus;
  final String? note;
  final List<CarService?>? carServices;
  final List<ETicket?>? eTicket;
  final String? subtotalPrice;
  final CarWorkshop? workshop;
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
    this.workshop,
    this.carServices,
    this.eTicket,
    required this.subtotalPrice,
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
    List<CarService?>? carServices,
    List<ETicket?>? eTicket,
    String? subtotalPrice,
    CarWorkshop? workshop,
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
      carServices: carServices ?? this.carServices,
      eTicket: eTicket ?? this.eTicket,
      subtotalPrice: subtotalPrice ?? this.subtotalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      workshop: workshop ?? this.workshop,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'userCarId': userCarId,
      'workshopId': workshopId,
      'workStatus': workStatus?.toMap(),
      'orderStatus': orderStatus?.toMap(),
      'note': note,
      'carServices': carServices?.map((x) => x?.toMap()).toList(),
      'eTicket': eTicket?.map((x) => x?.toMap()).toList(),
      'subtotalPrice': subtotalPrice,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'workshop': workshop?.toMap(),
    };
  }

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      id: map['id'] != null ? map['id'] as String? : '',
      userId: map['userId'] != null ? map['userId'] as String? : '',
      userCarId: map['userCarId'] != null ? map['userCarId'] as String? : '',
      workshopId: map['workshopId'] != null ? map['workshopId'] as String? : '',
      workStatus: map['workStatus'] != null
          ? WorkStatusExtension.fromMap(map['workStatus'] as String)
          : WorkStatus.INSPECTION,
      orderStatus: map['orderStatus'] != null
          ? OrderStatusExtension.fromMap(map['orderStatus'] as String)
          : OrderStatus.DRAFT,
      note: map['note'] != null ? map['note'] as String? : '',
      carServices: map['carServices'] != null
          ? List<CarService?>.from(
              (map['carServices'] as List<dynamic>).map<CarService?>(
                (x) => CarService?.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      eTicket: map['eTicket'] != null
          ? List<ETicket?>.from(
              (map['eTicket'] as List<dynamic>).map<ETicket>(
                (x) => ETicket?.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      workshop: map['workshop'] != null
          ? CarWorkshop.fromMap(map['workshop'] as Map<String, dynamic>)
          : null,
      subtotalPrice:
          map['subtotalPrice'] != null ? map['subtotalPrice'] as String? : '',
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
    return 'Orders(id: $id, userId: $userId, userCarId: $userCarId, workshopId: $workshopId, workStatus: $workStatus, orderStatus: $orderStatus, note: $note, carServices: $carServices, eTicket: $eTicket, subtotalPrice: $subtotalPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        listEquals(other.carServices, carServices) &&
        listEquals(other.eTicket, eTicket) &&
        other.subtotalPrice == subtotalPrice &&
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
        carServices.hashCode ^
        eTicket.hashCode ^
        subtotalPrice.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
