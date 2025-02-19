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
  DRAFT,
  CONFIRMED,
  PROCESSING,
  COMPLETED,
  CANCELLED,
}

extension OrderStatusExtension on OrderStatus {
  String toMap() {
    return name;
  }

  static OrderStatus fromMap(String status) {
    return OrderStatus.values.firstWhere((e) => e.name == status, orElse: null);
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

enum PaymentMethodType {
  EWALLET,
  BANK_TRANSFER,
  CREDIT_CARD,
  RETAIL_OUTLET,
  QRIS,
}

extension PaymentMethodTypeExtension on PaymentMethodType {
  String toMap() {
    return name;
  }

  static PaymentMethodType fromMap(String type) {
    return PaymentMethodType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => PaymentMethodType.EWALLET,
    );
  }
}
