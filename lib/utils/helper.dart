import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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

  /// Select image from the user file system
  static Future<File> selectImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<File> takeImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  static String formatDateMonth(DateTime dateTime) {
    var dateFormat = new DateFormat.MMMMd();
    return dateFormat.format(dateTime);
  }
}

const TAG = "[COVID]";
const ENABLE_PRINT_LOG = true;

printLog(dynamic data) {
  if (ENABLE_PRINT_LOG) {
    print("$TAG${data.toString()}");
  }
}

class AlgoliaKeys {
  static final Algolia algolia = Algolia.init(
    applicationId: '9IJQX7ANYL',
    apiKey: '71129391e8e03302f586339b22c2f76a',
  );
}
