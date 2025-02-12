import 'package:intl/intl.dart';

class FormatDate {
  static String createdAt(String createdAt) {
    DateTime dateTime = DateTime.parse(createdAt);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
}
