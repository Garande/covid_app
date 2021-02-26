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

  static String formatNumber(int number) {
    final numberFormat = new NumberFormat();
    return numberFormat.format(number);
  }
}

const TAG = "[COVID]";
const ENABLE_PRINT_LOG = true;

printLog(dynamic data) {
  if (ENABLE_PRINT_LOG) {
    print("$TAG${data.toString()}");
  }
}
