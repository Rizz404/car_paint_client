enum CancellationReason {
  CUSTOMER_REQUEST,
  WORKSHOP_UNAVAILABLE,
  SERVICE_UNAVAILABLE,
  SCHEDULING_CONFLICT,
  PAYMENT_ISSUE,
  VEHICLE_ISSUE,
  PRICE_DISAGREEMENT,
  WORKSHOP_OVERBOOKED,
  DUPLICATE_ORDER,
  PARTS_UNAVAILABLE,
  CUSTOMER_NO_SHOW,
  FORCE_MAJEURE,
  SERVICE_INCOMPATIBILITY,
  OTHER,
}

const Map<CancellationReason, String> cancellationReasonDescriptions = {
  CancellationReason.CUSTOMER_REQUEST: 'Permintaan pelanggan',
  CancellationReason.WORKSHOP_UNAVAILABLE: 'Bengkel tidak tersedia',
  CancellationReason.SERVICE_UNAVAILABLE: 'Layanan tidak tersedia',
  CancellationReason.SCHEDULING_CONFLICT: 'Konflik jadwal',
  CancellationReason.PAYMENT_ISSUE: 'Masalah pembayaran',
  CancellationReason.VEHICLE_ISSUE: 'Masalah kendaraan',
  CancellationReason.PRICE_DISAGREEMENT: 'Perbedaan harga',
  CancellationReason.WORKSHOP_OVERBOOKED: 'Bengkel kelebihan pesanan',
  CancellationReason.DUPLICATE_ORDER: 'Pesanan ganda',
  CancellationReason.PARTS_UNAVAILABLE: 'Suku cadang tidak tersedia',
  CancellationReason.CUSTOMER_NO_SHOW: 'Pelanggan tidak hadir',
  CancellationReason.FORCE_MAJEURE: 'Keadaan memaksa',
  CancellationReason.SERVICE_INCOMPATIBILITY: 'Layanan tidak cocok',
  CancellationReason.OTHER: 'Lainnya',
};

extension CancellationReasonExtension on CancellationReason {
  String toMap() {
    return name;
  }

  static CancellationReason fromMap(String status) {
    return CancellationReason.values.firstWhere(
      (e) => e.name == status,
      orElse: () => CancellationReason.CUSTOMER_REQUEST,
    );
  }
}
