// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentDetail {
  final String? id;
  final String? transactionId;
  final String? virtualAccountNumber;
  final String? invoiceUrl;
  final String? mobileUrl;
  final String? webUrl;
  final String? deeplinkUrl;
  final DateTime? paidAt;
  final String? midtransTransactionId;
  final String? midtransOrderId;
  final String? midtransPaymentType;
  final String? midtransTransactionStatus;
  final String? midtransFraudStatus;
  final String? midtransPaymentCode;
  final String? midtransBillKey;
  final String? midtransBillerCode;
  final String? midtransQrCodeUrl;
  final String? midtransRedirectUrl;
  final String? midtransExpiryTime;
  final String? snapToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  PaymentDetail({
    this.id,
    this.transactionId,
    this.virtualAccountNumber,
    this.invoiceUrl,
    this.mobileUrl,
    this.webUrl,
    this.deeplinkUrl,
    this.paidAt,
    this.midtransTransactionId,
    this.midtransOrderId,
    this.midtransPaymentType,
    this.midtransTransactionStatus,
    this.midtransFraudStatus,
    this.midtransPaymentCode,
    this.midtransBillKey,
    this.midtransBillerCode,
    this.midtransQrCodeUrl,
    this.midtransRedirectUrl,
    this.midtransExpiryTime,
    this.snapToken,
    this.createdAt,
    this.updatedAt,
  });

  PaymentDetail copyWith({
    String? id,
    String? transactionId,
    String? virtualAccountNumber,
    String? invoiceUrl,
    String? mobileUrl,
    String? webUrl,
    String? deeplinkUrl,
    DateTime? paidAt,
    String? midtransTransactionId,
    String? midtransOrderId,
    String? midtransPaymentType,
    String? midtransTransactionStatus,
    String? midtransFraudStatus,
    String? midtransPaymentCode,
    String? midtransBillKey,
    String? midtransBillerCode,
    String? midtransQrCodeUrl,
    String? midtransRedirectUrl,
    String? midtransExpiryTime,
    String? snapToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentDetail(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      virtualAccountNumber: virtualAccountNumber ?? this.virtualAccountNumber,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      mobileUrl: mobileUrl ?? this.mobileUrl,
      webUrl: webUrl ?? this.webUrl,
      deeplinkUrl: deeplinkUrl ?? this.deeplinkUrl,
      paidAt: paidAt ?? this.paidAt,
      midtransTransactionId:
          midtransTransactionId ?? this.midtransTransactionId,
      midtransOrderId: midtransOrderId ?? this.midtransOrderId,
      midtransPaymentType: midtransPaymentType ?? this.midtransPaymentType,
      midtransTransactionStatus:
          midtransTransactionStatus ?? this.midtransTransactionStatus,
      midtransFraudStatus: midtransFraudStatus ?? this.midtransFraudStatus,
      midtransPaymentCode: midtransPaymentCode ?? this.midtransPaymentCode,
      midtransBillKey: midtransBillKey ?? this.midtransBillKey,
      midtransBillerCode: midtransBillerCode ?? this.midtransBillerCode,
      midtransQrCodeUrl: midtransQrCodeUrl ?? this.midtransQrCodeUrl,
      midtransRedirectUrl: midtransRedirectUrl ?? this.midtransRedirectUrl,
      midtransExpiryTime: midtransExpiryTime ?? this.midtransExpiryTime,
      snapToken: snapToken ?? this.snapToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transactionId': transactionId,
      'virtualAccountNumber': virtualAccountNumber,
      'invoiceUrl': invoiceUrl,
      'mobileUrl': mobileUrl,
      'webUrl': webUrl,
      'deeplinkUrl': deeplinkUrl,
      'paidAt': paidAt?.toIso8601String(),
      'midtransTransactionId': midtransTransactionId,
      'midtransOrderId': midtransOrderId,
      'midtransPaymentType': midtransPaymentType,
      'midtransTransactionStatus': midtransTransactionStatus,
      'midtransFraudStatus': midtransFraudStatus,
      'midtransPaymentCode': midtransPaymentCode,
      'midtransBillKey': midtransBillKey,
      'midtransBillerCode': midtransBillerCode,
      'midtransQrCodeUrl': midtransQrCodeUrl,
      'midtransRedirectUrl': midtransRedirectUrl,
      'midtransExpiryTime': midtransExpiryTime,
      'snapToken': snapToken,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PaymentDetail.fromMap(Map<String, dynamic> map) {
    return PaymentDetail(
      id: map['id'] != null ? map['id'] as String : null,
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
      virtualAccountNumber: map['virtualAccountNumber'] != null
          ? map['virtualAccountNumber'] as String
          : null,
      invoiceUrl:
          map['invoiceUrl'] != null ? map['invoiceUrl'] as String : null,
      mobileUrl: map['mobileUrl'] != null ? map['mobileUrl'] as String : null,
      webUrl: map['webUrl'] != null ? map['webUrl'] as String : null,
      deeplinkUrl:
          map['deeplinkUrl'] != null ? map['deeplinkUrl'] as String : null,
      paidAt: map['paidAt'] != null
          ? DateTime.parse(map['paidAt'] as String)
          : null,
      midtransTransactionId: map['midtransTransactionId'] != null
          ? map['midtransTransactionId'] as String
          : null,
      midtransOrderId: map['midtransOrderId'] != null
          ? map['midtransOrderId'] as String
          : null,
      midtransPaymentType: map['midtransPaymentType'] != null
          ? map['midtransPaymentType'] as String
          : null,
      midtransTransactionStatus: map['midtransTransactionStatus'] != null
          ? map['midtransTransactionStatus'] as String
          : null,
      midtransFraudStatus: map['midtransFraudStatus'] != null
          ? map['midtransFraudStatus'] as String
          : null,
      midtransPaymentCode: map['midtransPaymentCode'] != null
          ? map['midtransPaymentCode'] as String
          : null,
      midtransBillKey: map['midtransBillKey'] != null
          ? map['midtransBillKey'] as String
          : null,
      midtransBillerCode: map['midtransBillerCode'] != null
          ? map['midtransBillerCode'] as String
          : null,
      midtransQrCodeUrl: map['midtransQrCodeUrl'] != null
          ? map['midtransQrCodeUrl'] as String
          : null,
      midtransRedirectUrl: map['midtransRedirectUrl'] != null
          ? map['midtransRedirectUrl'] as String
          : null,
      midtransExpiryTime: map['midtransExpiryTime'] != null
          ? map['midtransExpiryTime'] as String
          : null,
      snapToken: map['snapToken'] != null ? map['snapToken'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentDetail.fromJson(String source) =>
      PaymentDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentDetail(id: $id, transactionId: $transactionId, virtualAccountNumber: $virtualAccountNumber, invoiceUrl: $invoiceUrl, mobileUrl: $mobileUrl, webUrl: $webUrl, deeplinkUrl: $deeplinkUrl, paidAt: $paidAt, midtransTransactionId: $midtransTransactionId, midtransOrderId: $midtransOrderId, midtransPaymentType: $midtransPaymentType, midtransTransactionStatus: $midtransTransactionStatus, midtransFraudStatus: $midtransFraudStatus, midtransPaymentCode: $midtransPaymentCode, midtransBillKey: $midtransBillKey, midtransBillerCode: $midtransBillerCode, midtransQrCodeUrl: $midtransQrCodeUrl, midtransRedirectUrl: $midtransRedirectUrl, midtransExpiryTime: $midtransExpiryTime, snapToken: $snapToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PaymentDetail other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.transactionId == transactionId &&
        other.virtualAccountNumber == virtualAccountNumber &&
        other.invoiceUrl == invoiceUrl &&
        other.mobileUrl == mobileUrl &&
        other.webUrl == webUrl &&
        other.deeplinkUrl == deeplinkUrl &&
        other.paidAt == paidAt &&
        other.midtransTransactionId == midtransTransactionId &&
        other.midtransOrderId == midtransOrderId &&
        other.midtransPaymentType == midtransPaymentType &&
        other.midtransTransactionStatus == midtransTransactionStatus &&
        other.midtransFraudStatus == midtransFraudStatus &&
        other.midtransPaymentCode == midtransPaymentCode &&
        other.midtransBillKey == midtransBillKey &&
        other.midtransBillerCode == midtransBillerCode &&
        other.midtransQrCodeUrl == midtransQrCodeUrl &&
        other.midtransRedirectUrl == midtransRedirectUrl &&
        other.midtransExpiryTime == midtransExpiryTime &&
        other.snapToken == snapToken &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        transactionId.hashCode ^
        virtualAccountNumber.hashCode ^
        invoiceUrl.hashCode ^
        mobileUrl.hashCode ^
        webUrl.hashCode ^
        deeplinkUrl.hashCode ^
        paidAt.hashCode ^
        midtransTransactionId.hashCode ^
        midtransOrderId.hashCode ^
        midtransPaymentType.hashCode ^
        midtransTransactionStatus.hashCode ^
        midtransFraudStatus.hashCode ^
        midtransPaymentCode.hashCode ^
        midtransBillKey.hashCode ^
        midtransBillerCode.hashCode ^
        midtransQrCodeUrl.hashCode ^
        midtransRedirectUrl.hashCode ^
        midtransExpiryTime.hashCode ^
        snapToken.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
