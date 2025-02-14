// lib/utils/currency_formatter.dart

import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _rupiahFormat = NumberFormat("#,###", "id_ID")
    ..maximumFractionDigits = 0;

  /// Format number to Rupiah
  /// Example:
  /// 1000 -> Rp 1.000
  /// 10000 -> Rp 10.000
  /// 100000 -> Rp 100.000
  static String toRupiah(num number) {
    return "Rp. ${_rupiahFormat.format(number)}";
  }

  /// Format number to string with thousand separator
  /// Example:
  /// 1000 -> 1.000
  /// 10000 -> 10.000
  /// 100000 -> 100.000
  static String formatNumber(num number) {
    return _rupiahFormat.format(number);
  }

  /// Parse formatted string back to number
  /// Example: "1.000" -> 1000
  static num? parse(String formatted) {
    try {
      return _rupiahFormat.parse(formatted);
    } catch (e) {
      return null;
    }
  }
}
