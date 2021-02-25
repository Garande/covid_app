import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/database/dao/userDao.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/providers/provider.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataProvider extends BaseUserDataProvider {
  final firestoreDb = FirebaseFirestore.instance;
  final userDao = UserDao();

  @override
  Future<AppUser> saveDetailsFromGoogleAuth(User user, User googleUser,
      String phoneNumber, String countryCode, String userId) async {
    DocumentReference docReference =
        firestoreDb.collection(Paths.usersPath).doc(userId);
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
      data['photoUrl'] = googleUser.photoURL;
    }
    return await updateUserDetails(userId, data);
  }

  @override
  Future<AppUser> saveUserProfileDetails(AppUser user) async {
    return updateUserDetails(user.userId, user.toJson());
  }

  @override
  Future<AppUser> getUserByLogInId(String loginId) async {
    return await userDao.fetchUserByLogInId(loginId: loginId);
  }

  @override
  Future<AppUser> updateUserDetails(
      String userId, Map<String, dynamic> userData) async {
    DocumentReference docReference =
        firestoreDb.collection(Paths.usersPath).doc(userId);
    docReference.set(userData, SetOptions(merge: true));
    final DocumentSnapshot currentDocument = await docReference.get();
    AppUser userObject = AppUser.fromFirestore(currentDocument);
    bool isSavedInLocalDb = await userDao.isExist(userId);
    if (isSavedInLocalDb) {
      await userDao.update(userObject);
    } else {
      await userDao.insert(userObject);
    }
    return userObject;
  }

  @override
  Future<AppUser> getUserByUserId(String userId) {
    return Paths.retrieveUserDbPath(userId)
        .get()
        .then((doc) => AppUser.fromFirestore(doc));
  }
}
