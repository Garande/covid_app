import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopesha/models/account.dart';
import 'package:kopesha/models/accountSummary.dart';
import 'package:kopesha/models/transaction.dart';
import 'package:kopesha/models/userObject.dart';

abstract class BaseAuthenticationProvider {
  Future<FirebaseUser> signInWithGoogle();
  Future<void> signOutUser();
  Future<FirebaseUser> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> sendOtp(
      String phoneNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout);
  Future<AuthResult> verifyPhoneNumber(String verificationId, String smsCode);
}

abstract class BaseUserDataProvider {
  Future<UserObject> saveDetailsFromGoogleAuth(
      FirebaseUser user,
      FirebaseUser googleUser,
      String phoneNumber,
      String countryCode,
      String userId);
  Future<UserObject> saveUserProfileDetails(UserObject user);

  Future<UserObject> getUserByLogInId(String loginId);

  Future<UserObject> getUserByUserId(String userId);

  Future<UserObject> updateUserDetails(
      String userId, Map<String, dynamic> userData);
  // Future<bool> isUserProfileExist(
  //     String loginId); //loginId = uid from firebaseUser;
}

abstract class BaseStorageProvider {
  Future<String> uploadImage(File file, String storagePath);
}

abstract class BaseTransactionsProvider {
  Future<Null> submitDebtRepay(Transaction transaction);

  Future<Null> submitAccountRecharge(Transaction transaction);

  Future<Transaction> fetchLastTransaction(String userId);

  Future<List<Transaction>> fetchUserTransactions(String userId);

  Future<AccountSummary> fetchUserAccountSummary(String userId);

  Future<Null> submitUserAccount(Account account);

  Future<List<Account>> fetchUserAccounts(String userId);
}
