enum PaymentReusability {
  ONE_TIME_USE,
  MULTIPLE_USE,
}

const Map<PaymentReusability, String> paymentMethodReusabilityDescriptions = {
  PaymentReusability.ONE_TIME_USE: 'One Time Use',
  PaymentReusability.MULTIPLE_USE: 'Multiple Use',
};

extension PaymentReusabilityExtension on PaymentReusability {
  String toMap() {
    return name;
  }

  static PaymentReusability fromMap(String status) {
    return PaymentReusability.values.firstWhere(
      (e) => e.name == status,
      orElse: () => PaymentReusability.ONE_TIME_USE,
    );
  }
}
