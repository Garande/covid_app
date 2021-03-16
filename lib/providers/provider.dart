import 'dart:async';
import 'dart:io';

import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/driver.dart';
import 'package:covid_app/models/question.dart';
import 'package:covid_app/models/trip.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/models/vehicle_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

  Future<void> saveDriver(Driver driver);

  Future<Driver> fetchDriverById(String userId);

  searchUser(String query) {}
  // Future<bool> isUserProfileExist(
  //     String loginId); //loginId = uid from firebaseUser;
}

abstract class BaseCoronaProvider {
  Future<List<Question>> fetchSelfTestQuestions();
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

  Future<void> saveDriverInfo(Driver driver);

  Future<Driver> fetchDriverInfo(String driverId);

  Future<void> boardVehicle(Trip trip);

  Future<void> updateTripInfo(Trip trip);

  Future<Trip> fetchTripInfo(String driverId, String userId);

  Future<Trip> fetchTripFromId(String id);

  Future<List<VehicleType>> fetchVehicleTypes();

  Future<VehicleType> fetchVehicleTypeById(String id);

  StreamSubscription<Event> listenToStartTrip(AppUser appUser);

  StreamSubscription<Event> listenToEndTrip(AppUser appUser);

  Future<void> startTrip(Trip trip);

  Future<void> endTrip(Trip trip);

  Future<List<AppUser>> searchUser(String query);
  // Future<void> updateTripDestination(Address address, )
}
