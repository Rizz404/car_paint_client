enum WorkStatus {
  QUEUED,
  INSPECTION,
  PUTTY,
  SURFACER,
  APPLICATION_COLOR_BASE,
  APPLICATION_CLEAR_COAT,
  POLISHING,
  FINAL_QC,
  COMPLETED,
  CANCELLED,
}

const Map<WorkStatus, String> workStatusDescriptions = {
  WorkStatus.QUEUED:
      'Pekerjaan Anda telah masuk dalam antrian dan menunggu giliran untuk diproses.',
  WorkStatus.INSPECTION:
      'Kendaraan Anda sedang dalam tahap inspeksi untuk menilai kondisi dan kebutuhan perbaikan.',
  WorkStatus.PUTTY:
      'Proses pengisian dempul pada area yang memerlukan perbaikan untuk meratakan permukaan.',
  WorkStatus.SURFACER:
      'Penerapan lapisan dasar untuk memastikan cat menempel dengan baik dan merata.',
  WorkStatus.APPLICATION_COLOR_BASE:
      'Aplikasi warna dasar sesuai dengan pilihan Anda.',
  WorkStatus.APPLICATION_CLEAR_COAT:
      'Penerapan lapisan pelindung bening untuk melindungi dan memberikan kilau pada cat.',
  WorkStatus.POLISHING:
      'Proses pemolesan untuk menghilangkan ketidaksempurnaan dan meningkatkan kilau.',
  WorkStatus.FINAL_QC:
      'Kontrol kualitas akhir untuk memastikan semua pekerjaan telah dilakukan dengan standar tinggi.',
  WorkStatus.COMPLETED:
      'Pekerjaan telah selesai dan kendaraan siap untuk diserahkan.',
  WorkStatus.CANCELLED: 'Pekerjaan telah dibatalkan.',
};

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

final Map<PaymentStatus, String> paymentStatusLabels = {
  PaymentStatus.SUCCESS: 'Berhasil',
  PaymentStatus.PENDING: 'Menunggu',
  PaymentStatus.FAILED: 'Gagal',
  PaymentStatus.EXPIRED: 'Kedaluwarsa',
  PaymentStatus.REFUNDED: 'Dikembalikan',
};

enum PaymentMethodType {
  CARD,
  DIRECT_DEBIT,
  EWALLET,
  OVER_THE_COUNTER,
  QR_CODE,
  VIRTUAL_ACCOUNT,
  UNKNOWN_ENUM_VALUE,
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
