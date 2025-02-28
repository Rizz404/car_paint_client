enum PaymentMethodType {
  CARD,
  DIRECT_DEBIT,
  EWALLET,
  OVER_THE_COUNTER,
  QR_CODE,
  VIRTUAL_ACCOUNT,
  UNKNOWN_ENUM_VALUE,
}

const Map<PaymentMethodType, String> paymentMethodTypeDescriptions = {
  PaymentMethodType.CARD: 'Card',
  PaymentMethodType.DIRECT_DEBIT: 'Direct Debit',
  PaymentMethodType.EWALLET: 'E-Wallet',
  PaymentMethodType.OVER_THE_COUNTER: 'Over The Counter',
  PaymentMethodType.QR_CODE: 'QR Code',
  PaymentMethodType.VIRTUAL_ACCOUNT: 'Virtual Account',
  PaymentMethodType.UNKNOWN_ENUM_VALUE: 'Unknown',
};

extension PaymentMethodTypeExtension on PaymentMethodType {
  String toMap() {
    return name;
  }

  static PaymentMethodType fromMap(String status) {
    return PaymentMethodType.values.firstWhere(
      (e) => e.name == status,
      orElse: () => PaymentMethodType.CARD,
    );
  }
}
