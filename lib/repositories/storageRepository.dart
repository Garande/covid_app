import 'dart:io';

import 'package:covid_app/providers/storageProvider.dart';

class StorageRepository {
  StorageProvider storageProvider = StorageProvider();

  Future<String> uploadImage(File file, String storagePath) =>
      storageProvider.uploadImage(file, storagePath);
}
