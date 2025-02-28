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
  final String? xenditInvoiceId;
  final String? xenditPaymentRequestId;
  final String? xenditPaymentMethodId;
  final DateTime? paidAt;
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
    this.xenditInvoiceId,
    this.xenditPaymentRequestId,
    this.xenditPaymentMethodId,
    this.paidAt,
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
    String? xenditInvoiceId,
    String? xenditPaymentRequestId,
    String? xenditPaymentMethodId,
    DateTime? paidAt,
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
      xenditInvoiceId: xenditInvoiceId ?? this.xenditInvoiceId,
      xenditPaymentRequestId:
          xenditPaymentRequestId ?? this.xenditPaymentRequestId,
      xenditPaymentMethodId:
          xenditPaymentMethodId ?? this.xenditPaymentMethodId,
      paidAt: paidAt ?? this.paidAt,
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
      'xenditInvoiceId': xenditInvoiceId,
      'xenditPaymentRequestId': xenditPaymentRequestId,
      'xenditPaymentMethodId': xenditPaymentMethodId,
      'paidAt': paidAt?.millisecondsSinceEpoch,
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
      xenditInvoiceId: map['xenditInvoiceId'] != null
          ? map['xenditInvoiceId'] as String
          : null,
      xenditPaymentRequestId: map['xenditPaymentRequestId'] != null
          ? map['xenditPaymentRequestId'] as String
          : null,
      xenditPaymentMethodId: map['xenditPaymentMethodId'] != null
          ? map['xenditPaymentMethodId'] as String
          : null,
      paidAt: map['paidAt'] != null
          ? DateTime.parse(map['paidAt'] as String)
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

  factory PaymentDetail.fromJson(String source) =>
      PaymentDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentDetail(id: $id, transactionId: $transactionId, virtualAccountNumber: $virtualAccountNumber, invoiceUrl: $invoiceUrl, mobileUrl: $mobileUrl, webUrl: $webUrl, deeplinkUrl: $deeplinkUrl, xenditInvoiceId: $xenditInvoiceId, xenditPaymentRequestId: $xenditPaymentRequestId, xenditPaymentMethodId: $xenditPaymentMethodId, paidAt: $paidAt, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        other.xenditInvoiceId == xenditInvoiceId &&
        other.xenditPaymentRequestId == xenditPaymentRequestId &&
        other.xenditPaymentMethodId == xenditPaymentMethodId &&
        other.paidAt == paidAt &&
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
        xenditInvoiceId.hashCode ^
        xenditPaymentRequestId.hashCode ^
        xenditPaymentMethodId.hashCode ^
        paidAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
