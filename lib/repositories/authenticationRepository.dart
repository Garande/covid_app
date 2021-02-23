import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopesha/providers/authenticationProvider.dart';
import 'package:kopesha/providers/provider.dart';

class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<FirebaseUser> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => authenticationProvider.signOutUser();

  Future<FirebaseUser> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

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
  Future<AuthResult> verifyPhoneNumber(String verificationId, String smsCode) =>
      authenticationProvider.verifyPhoneNumber(verificationId, smsCode);
}
