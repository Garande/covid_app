import 'dart:io';

import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthenticationProvider {
  Future<User> signInWithGoogle();
  Future<void> signOutUser();
  User getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> sendOtp(
      String phoneNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout);
  Future<UserCredential> verifyPhoneNumber(
      String verificationId, String smsCode);
}

abstract class BaseUserDataProvider {
  Future<AppUser> saveDetailsFromGoogleAuth(User user, User googleUser,
      String phoneNumber, String countryCode, String userId);
  Future<AppUser> saveUserProfileDetails(AppUser user);

  Future<AppUser> getUserByLogInId(String loginId);

  Future<AppUser> getUserByUserId(String userId);

  Future<AppUser> updateUserDetails(
      String userId, Map<String, dynamic> userData);
  // Future<bool> isUserProfileExist(
  //     String loginId); //loginId = uid from firebaseUser;
}

abstract class BaseStorageProvider {
  Future<String> uploadImage(File file, String storagePath);
}

abstract class BaseMovementsProvider {
  Future<void> saveUserMovement(UserMovement userMovement);

  Future<List<UserMovement>> fetchUserMovements(String userId);

  Future<UserMovement> fetchUserLastMovement(String userId);

  Future<List<UserMovement>> fetchUserMovementsBetween(
      String userId, DateTime dateTimeFrom, DateTime dateTimeTo);
}
