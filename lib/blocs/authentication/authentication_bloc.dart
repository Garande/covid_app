import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/repositories/authenticationRepository.dart';
import 'package:covid_app/repositories/storageRepository.dart';
import 'package:covid_app/repositories/userRepository.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  String verificationId = "";
  StreamSubscription subscription;

  AuthenticationBloc(
      {this.authenticationRepository,
      this.userDataRepository,
      this.storageRepository})
      : assert(authenticationRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null),
        super(null);
  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppLaunched)
      yield* mapAppLaunchedToState();
    else if (event is ClickedGooglSignIn)
      yield* mapClickedGoogleSignInToState();
    else if (event is GoogleUserLoggedIn)
      yield* mapGoogleUserLoggedIn();
    else if (event is SendOtpEvent) {
      yield AuthInProgress();
      subscription = sendOtp(event.phoneNumber, event.countryCode, event.userId,
              event.googleUser)
          .listen((onData) {
        add(onData);
      });
      // yield WaitingOtpVerificationState();
    } else if (event is OtpSendEvent) {
      //resend otp to user
      yield OtpSentState();
      // yield WaitingOtpVerificationState();
    } else if (event is AuthExceptionEvent)
      yield AuthExceptionState(message: event.message);
    else if (event is VerifyOtpEvent)
      yield* mapVerifyOtpToState(event.otp, event.phoneNumber,
          event.countryCode, event.userId, event.googleUser);
    else if (event is LoggedIn)
      yield* mapLoggedInToState(event.user, event.googleUser, event.phoneNumber,
          event.countryCode, event.userId);
    else if (event is PickedProfilePicture)
      yield ReceivedProfilePicture(event.file);
    else if (event is SaveUserProfile)
      yield* mapSaveUserProfileToState(event.profileImage, event.user);
    else if (event is ClickedLogout)
      yield* mapLoggedOutToState();
    else if (event is ResendOtpEvent) yield* mapResendOtpToState(event);
  }

  Stream<AuthenticationState> mapAppLaunchedToState() async* {
    try {
      yield AuthInProgress(); //progress bar

      final isSignedIn = await authenticationRepository.isLoggedIn();
      if (isSignedIn) {
        //user already signed in
        final firebaseUser = await authenticationRepository.getCurrentUser();
        //check user profile using login id
        bool isUserProfileExist =
            await userDataRepository.isUserProfileExist(firebaseUser.uid);

        if (isUserProfileExist) {
          //user data exist redirect to home page
          yield ProfileUpdated();
        } else {
          //complete user profile
          if (firebaseUser != null) {
            yield GoogleAuthenticated(firebaseUser);
            add(GoogleUserLoggedIn(firebaseUser));
          }

          // yield Authenticated(firebaseUser);
          // //get google details to prefill
          // add(LoggedIn(firebaseUser));
        }
      } else {
        //user is authenticated
        yield UnAuthenticated();
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapClickedGoogleSignInToState() async* {
    yield AuthInProgress();
    try {
      User authenticatedUser = authenticationRepository.getCurrentUser();
      if (authenticatedUser != null) {
        yield GoogleAuthenticated(authenticatedUser);
      } else {
        User firebaseUser = await authenticationRepository
            .signInWithGoogle()
            .catchError((onError) async* {
          yield AuthExceptionState(message: 'Google Login failed');
        });

        if (firebaseUser != null) {
          // print('===========================================>');
          // print('Iam not null');
          yield GoogleAuthenticated(firebaseUser);
        } else {
          yield UnAuthenticated();
        }
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapResendOtpToState(event) async* {
    yield AuthInProgress();
    subscription = sendOtp(
            (event as SendOtpEvent).phoneNumber,
            (event as SendOtpEvent).countryCode,
            (event as SendOtpEvent).userId,
            (event as SendOtpEvent).googleUser)
        .listen((onData) {
      add(onData);
    });
  }

  Stream<AuthenticationEvent> sendOtp(String phoneNumber, String countryCode,
      String userId, User googleUser) async* {
    StreamController<AuthenticationEvent> eventStream = StreamController();
    try {
      final phoneVerificationCompleted = (AuthCredential authCredential) {
        User user = authenticationRepository.getCurrentUser();
        eventStream
            .add(LoggedIn(user, googleUser, phoneNumber, countryCode, userId));
        eventStream.close();
      };

      final phoneVerificationFailed = (FirebaseAuthException authException) {
        print(authException.message);
        eventStream.add(AuthExceptionEvent(authException.toString()));
        eventStream.close();
      };

      final phoneCodeSent = (String verId, [int forceResent]) {
        this.verificationId = verId;
        eventStream.add(OtpSendEvent());
      };

      final phoneCodeAutoRetrievalTimeout = (String verId) {
        this.verificationId = verId;
        eventStream.close();
      };

      await authenticationRepository.sendOtp(
          phoneNumber,
          Duration(seconds: 1),
          phoneVerificationFailed,
          phoneVerificationCompleted,
          phoneCodeSent,
          phoneCodeAutoRetrievalTimeout);
    } catch (e) {
      printLog('################################');
      printLog(e);
    }

    yield* eventStream.stream;
  }

  Stream<AuthenticationState> mapVerifyOtpToState(
      String otp,
      String phoneNumber,
      String countryCode,
      String userId,
      User googleUser) async* {
    yield AuthInProgress();
    print(otp);
    try {
      UserCredential result =
          await authenticationRepository.verifyPhoneNumber(verificationId, otp);

      if (result.user != null) {
        bool isUserProfileExist =
            await userDataRepository.isUserProfileExist(result.user.uid);

        if (isUserProfileExist) {
          //user data exist redirect to home page
          yield OtpVerifiedState();
          yield ProfileUpdated();
        } else {
          //complete user profile
          yield Authenticated(result.user);
          //get google details to prefill
          add(LoggedIn(
              result.user, googleUser, phoneNumber, countryCode, userId));
        }
        // yield Authenticated(result.user);
      } else
        yield OtpExceptionState(message: "Invalid otp!");
    } catch (e) {
      yield OtpExceptionState(message: "Invalid otp!");
      print(e);
    }
  }

  Stream<AuthenticationState> mapLoggedInToState(
      User firebaseUser,
      User googleUser,
      String phoneNumber,
      String countryCode,
      String userId) async* {
    yield ProfileUpdateInProgress();
    AppUser user = await userDataRepository.saveDetailsFromGoogleAuth(
        firebaseUser,
        googleUser,
        phoneNumber,
        countryCode,
        userId); //save google user data to firestore
    yield PreFillData(user);
  }

  Stream<AuthenticationState> mapGoogleUserLoggedIn() async* {
    User firebaseUser = authenticationRepository.getCurrentUser();
    if (firebaseUser != null) {
      yield GoogleAuthenticated(firebaseUser);
    } else {
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapSaveUserProfileToState(
      File profileImage, AppUser user) async* {
    yield ProfileUpdateInProgress();
    if (profileImage != null) {
      String photoUrl = await storageRepository.uploadImage(
          profileImage, Paths.profilePicturePath);

      user.photoUrl = photoUrl;
    }
    await userDataRepository.saveUserProfileDetails(user);
    yield ProfileComplete(); //redirect to home page
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield UnAuthenticated(); //redirect to get started
    authenticationRepository.signOutUser();
  }

  Future<AppUser> getCurrentUser() async {
    User firebaseUser = authenticationRepository.getCurrentUser();
    if (firebaseUser != null) {
      AppUser user =
          await userDataRepository.getUserByLoginId(firebaseUser.uid);
      return user;
    }
    return null;
  }

  Future<List<AppUser>> fetchSystemUsers() {
    return userDataRepository.fetchSystemUsers();
  }

  Future<AppUser> getUserByUserId(String userId) {
    return userDataRepository.getUserByUserId(userId);
  }

  @override
  void onEvent(AuthenticationEvent event) {
    super.onEvent(event);
    print(event);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print(stackTrace);
  }

  Future<void> close() async {
    print('Bloc Closed');
    subscription.cancel();
    super.close();
  }
}
