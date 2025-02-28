// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Cancellation {
  final String? id;
  final String? transactionId;
  final String? notes;
  final String? cancelledById;
  final DateTime? cancelledAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  Cancellation({
    this.id,
    this.transactionId,
    this.notes,
    this.cancelledById,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
  });

  Cancellation copyWith({
    String? id,
    String? transactionId,
    String? notes,
    String? cancelledById,
    DateTime? cancelledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cancellation(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
      cancelledById: cancelledById ?? this.cancelledById,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transactionId': transactionId,
      'notes': notes,
      'cancelledById': cancelledById,
      'cancelledAt': cancelledAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Cancellation.fromMap(Map<String, dynamic> map) {
    return Cancellation(
      id: map['id'] != null ? map['id'] as String : null,
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      cancelledById:
          map['cancelledById'] != null ? map['cancelledById'] as String : null,
      cancelledAt: map['cancelledAt'] != null
          ? DateTime.parse(map['cancelledAt'] as String)
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

  factory Cancellation.fromJson(String source) =>
      Cancellation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cancellation(id: $id, transactionId: $transactionId, notes: $notes, cancelledById: $cancelledById, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Cancellation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.transactionId == transactionId &&
        other.notes == notes &&
        other.cancelledById == cancelledById &&
        other.cancelledAt == cancelledAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        transactionId.hashCode ^
        notes.hashCode ^
        cancelledById.hashCode ^
        cancelledAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
