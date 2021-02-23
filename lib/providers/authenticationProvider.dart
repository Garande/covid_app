import 'package:covid_app/providers/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  User getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  @override
  Future<bool> isLoggedIn() async {
    final firebaseUser = firebaseAuth.currentUser;
    return firebaseUser != null;
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount account =
        await googleSignIn.signIn().catchError((onError) {
      print(onError);
    });

    final GoogleSignInAuthentication authentication =
        await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    await firebaseAuth.signInWithCredential(credential);
    return firebaseAuth.currentUser;
  }

  @override
  Future<void> signOutUser() async {
    return Future.wait(
        [firebaseAuth.signOut(), googleSignIn.signOut()]); //close all sessions
  }

  @override
  Future<void> sendOtp(
      String phoneNumber,
      Duration timeOut,
      phoneVerificationFailed,
      phoneVerificationCompleted,
      phoneCodeSent,
      autoRetrievalTimeout) async {
    firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeOut,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  @override
  Future<UserCredential> verifyPhoneNumber(
      String verificationId, String smsCode) {
    AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return firebaseAuth.signInWithCredential(authCredential);
  }
}
