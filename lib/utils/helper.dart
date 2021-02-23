import 'package:intl/intl.dart';

class Helper {
  static String formatCurrency(double amount) {
    final number = new NumberFormat("#,##0.0", "en_US");
    return number.format(amount);
  }

  static String formatDateWithTime(DateTime dateTime) {
    var dateFormat = new DateFormat.yMd().add_jm();
    return dateFormat.format(dateTime);
  }
}
