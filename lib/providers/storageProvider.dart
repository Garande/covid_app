import 'dart:io';

import 'package:covid_app/providers/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageProvider extends BaseStorageProvider {
  final firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;
  @override
  Future<String> uploadImage(File file, String storagePath) async {
    firebase_storage.Reference reference =
        firebaseStorage.ref().child(storagePath);
    firebase_storage.UploadTask uploadTask = reference.putFile(file);
    firebase_storage.TaskSnapshot result =
        uploadTask.snapshot; //wait for upload to complete
    String url = await result.ref.getDownloadURL();
    return url;
  }
}
