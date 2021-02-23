import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopesha/database/dao/userDao.dart';
import 'package:kopesha/models/userObject.dart';
import 'package:kopesha/providers/provider.dart';
import 'package:kopesha/providers/userDataProvider.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();
  final userDao = UserDao();

  Future<UserObject> saveDetailsFromGoogleAuth(
          FirebaseUser user,
          FirebaseUser googleUser,
          String phoneNumber,
          String countryCode,
          String userId) =>
      userDataProvider.saveDetailsFromGoogleAuth(
          user, googleUser, phoneNumber, countryCode, userId);

  Future<UserObject> saveUserProfileDetails(UserObject user) async {
    return await userDataProvider.saveUserProfileDetails(user);
  }

  Future<UserObject> updateUserDetails(
          String userId, Map<String, dynamic> userData) async =>
      await userDataProvider.updateUserDetails(userId, userData);

  Future<bool> isUserProfileExist(String loginId /**FirebaseUser.uid */) =>
      userDao.isUserExistByLoginId(loginId);

  //handle local db operations
  Future getAllLocalUsers({String query}) => userDao.fetchAll(query: query);

  Future getUserFromLocal({String id}) => userDao.fetchSingle(id: id);

  Future saveUserToLocal(UserObject user) => userDao.insert(user);

  Future updateUserInLocal(UserObject user) => userDao.update(user);

  Future deleteUserInLocalById(String userId) => userDao.delete(userId);

  Future<UserObject> getUserByLoginId(String uid) =>
      userDataProvider.getUserByLogInId(uid);

  Future<UserObject> getUserByUserId(String userId) =>
      userDataProvider.getUserByUserId(userId);
}
