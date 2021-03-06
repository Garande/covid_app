import 'package:covid_app/database/dao/userDao.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/driver.dart';
import 'package:covid_app/providers/provider.dart';
import 'package:covid_app/providers/userDataProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();
  final userDao = UserDao();

  Future<AppUser> saveDetailsFromGoogleAuth(User user, User googleUser,
          String phoneNumber, String countryCode, String userId) =>
      userDataProvider.saveDetailsFromGoogleAuth(
          user, googleUser, phoneNumber, countryCode, userId);

  Future<AppUser> saveUserProfileDetails(AppUser user) async {
    return userDataProvider.saveUserProfileDetails(user);
  }

  Future<AppUser> updateUserDetails(
          String userId, Map<String, dynamic> userData) async =>
      await userDataProvider.updateUserDetails(userId, userData);

  Future<bool> isUserProfileExist(String loginId /**User.uid */) =>
      userDao.isUserExistByLoginId(loginId);

  //handle local db operations
  Future getAllLocalUsers({String query}) => userDao.fetchAll(query: query);

  Future getUserFromLocal({String id}) => userDao.fetchSingle(id: id);

  Future saveUserToLocal(AppUser user) => userDao.insert(user);

  Future updateUserInLocal(AppUser user) => userDao.update(user);

  Future deleteUserInLocalById(String userId) => userDao.delete(userId);

  Future<AppUser> getUserByLoginId(String uid) =>
      userDataProvider.getUserByLogInId(uid);

  Future<AppUser> getUserByUserId(String userId) =>
      userDataProvider.getUserByUserId(userId);

  Future<void> saveDriver(Driver driver) => userDataProvider.saveDriver(driver);
}
