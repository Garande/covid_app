import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kopesha/providers/provider.dart';

class StorageProvider extends BaseStorageProvider {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  @override
  Future<String> uploadImage(File file, String storagePath) async {
    StorageReference reference = firebaseStorage.ref().child(storagePath);
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot result =
        await uploadTask.onComplete; //wait for upload to complete
    String url = await result.ref.getDownloadURL();
    return url;
  }
}
