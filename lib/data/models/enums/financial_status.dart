enum WorkStatus {
  INSPECTION,
  PUTTY,
  SURFACER,
  APPLICATION_COLOR_BASE,
  APPLICATION_CLEAR_COAT,
  POLISHING,
  FINALQC,
  DONE,
}

extension WorkStatusExtension on WorkStatus {
  String toMap() {
    return name; // Konversi enum ke string
  }

  static WorkStatus fromMap(String status) {
    return WorkStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => WorkStatus.INSPECTION,
    );
  }
}

enum OrderStatus {
  PENDING,
  ACCEPTED,
  CANCELLED,
}

extension OrderStatusExtension on OrderStatus {
  String toMap() {
    return name;
  }

  static OrderStatus fromMap(String status) {
    return OrderStatus.values
        .firstWhere((e) => e.name == status, orElse: () => OrderStatus.PENDING);
  }
}

enum PaymentStatus { PENDING, SUCCESS, EXPIRED, FAILED, REFUNDED }

extension PaymentStatusExtension on PaymentStatus {
  String toMap() {
    return name;
  }

  static PaymentStatus fromMap(String status) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => PaymentStatus.PENDING,
    );
  }
}
