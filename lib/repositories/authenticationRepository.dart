import 'package:covid_app/providers/authenticationProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  AuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<User> signInWithGoogle() => authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => authenticationProvider.signOutUser();

  User getCurrentUser() => authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();

  Future<void> sendOtp(
          String phoneNumber,
          Duration timeOut,
          PhoneVerificationFailed phoneVerificationFailed,
          PhoneVerificationCompleted phoneVerificationCompleted,
          PhoneCodeSent phoneCodeSent,
          PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout) =>
      authenticationProvider.sendOtp(
          phoneNumber,
          timeOut,
          phoneVerificationFailed,
          phoneVerificationCompleted,
          phoneCodeSent,
          autoRetrievalTimeout);
  Future<UserCredential> verifyPhoneNumber(
          String verificationId, String smsCode) =>
      authenticationProvider.verifyPhoneNumber(verificationId, smsCode);
}
