import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopesha/database/dao/userDao.dart';
import 'package:kopesha/providers/provider.dart';
import 'package:kopesha/utils/Paths.dart';
import 'package:kopesha/models/userObject.dart';

class UserDataProvider extends BaseUserDataProvider {
  final firestoreDb = Firestore.instance;
  final userDao = UserDao();

  @override
  Future<UserObject> saveDetailsFromGoogleAuth(
      FirebaseUser user,
      FirebaseUser googleUser,
      String phoneNumber,
      String countryCode,
      String userId) async {
    DocumentReference docReference =
        firestoreDb.collection(Paths.usersPath).document(userId);
    final bool userExists = await docReference.snapshots().isEmpty;
    var data = {
      'loginId': user.uid,
      'email': googleUser.email,
      'name': googleUser.displayName,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode
    };
    if (!userExists) {
      data['photoUrl'] = googleUser.photoUrl;
    }
    return await updateUserDetails(userId, data);
  }

  @override
  Future<UserObject> saveUserProfileDetails(UserObject user) async {
    return await updateUserDetails(user.userId, user.toJson());
  }

  @override
  Future<UserObject> getUserByLogInId(String loginId) async {
    return await userDao.fetchUserByLogInId(loginId: loginId);
  }

  @override
  Future<UserObject> updateUserDetails(
      String userId, Map<String, dynamic> userData) async {
    DocumentReference docReference =
        firestoreDb.collection(Paths.usersPath).document(userId);

    docReference.setData(userData);
    final DocumentSnapshot currentDocument = await docReference.get();
    UserObject userObject = UserObject.fromFirestore(currentDocument);
    bool isSavedInLocalDb = await userDao.isExist(userId);
    if (isSavedInLocalDb) {
      await userDao.update(userObject);
    } else {
      await userDao.insert(userObject);
    }
    return userObject;
  }

  @override
  Future<UserObject> getUserByUserId(String userId) {
    return Paths.retrieveUserDbPath(userId)
        .get()
        .then((doc) => UserObject.fromFirestore(doc));
  }
}
