import 'package:cloud_firestore/cloud_firestore.dart';

class Paths {
  /*
  Firebase paths
   */

  static CollectionReference getSystemDefaultsPath() =>
      firestoreDb.collection('/SYSTEM/SETTINGS/DEFAULTS');

  static const String profilePicturePath = 'profile_pictures';
  static const String usersPath = '/users';

  //image paths
  static const String appLogoPath = 'assets/images/logo.png';
  static const String yellowBirdLogoPath = 'assets/images/yb_logo2.png';

  static final firestoreDb = FirebaseFirestore.instance;

  static DocumentReference retrieveUserDbPath(String userId) =>
      firestoreDb.collection(usersPath).doc(userId);

  static String generateFirestoreDbKey(
      List<String> keyIdentifiers, int timestamp) {
    String key = '';

    keyIdentifiers.forEach((keyId) {
      if (key == '')
        key = keyId;
      else
        key = key + "-" + keyId;
    });

    key = key + "-" + timestamp.toString();

    return cleanFirestoreDbKey(key);
  }

  static String cleanFirestoreDbKey(String key) {
    key = key.replaceAll(" ", "-");
    key = key.replaceAll("/", "-");
    key = key.replaceAll("\\", "-");
    key = key.replaceAll("_", "-");
    key = key.replaceAll("--", "-");
    key = key.replaceAll("- -", "-");
    key = key.replaceAll(",,", ",");
    key = key.replaceAll(".", "-");
    key = key.replaceAll(".", "-");
    key = key.replaceAll("[", "-");
    key = key.replaceAll("]", "-");
    key = key.replaceAll("{", "-");
    key = key.replaceAll("}", "-");
    key = key.replaceAll("(", "-");
    key = key.replaceAll(")", "-");
    key = key.replaceAll("\$", "-");
    key = key.replaceAll("&", "-");
    key = key.replaceAll("'", "-");
    key = key.replaceAll("\"", "-");
    key = key.replaceAll("#", "-");
    key = key.replaceAll("-null", "");
    key = key.replaceAll("null-", "");
    key = key.replaceAll("null_", "");
    key = key.replaceAll("_null", "");
    key = key.replaceAll("0x00", "-");
    key = key.replaceAll("0x1F", "-");
    key = key.replaceAll("0x7F", "-");
    if (key.length >= 768)
      key = key.substring(0,
          500); //768 is the max number of character a downloadPath can contain.
    return key;
  }
}
