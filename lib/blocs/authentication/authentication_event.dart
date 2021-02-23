part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppLaunched extends AuthenticationEvent {
  @override
  String toString() => 'AppLaunched';

  @override
  List<Object> get props => [];
}

class ClickedGooglSignIn extends AuthenticationEvent {
  @override
  String toString() => 'ClickedGoogleSignIn';

  @override
  List<Object> get props => [];
}

class GoogleUserLoggedIn extends AuthenticationEvent {
  // final String token;
  final FirebaseUser user;
  GoogleUserLoggedIn(this.user);
  @override
  String toString() => 'GoogleUserLoggedIn';

  @override
  List<Object> get props => [user];
}

class SendOtpEvent extends AuthenticationEvent {
  final String phoneNumber;
  final String countryCode;
  final String userId;
  final FirebaseUser googleUser;

  SendOtpEvent(
      {this.countryCode, this.userId, this.phoneNumber, this.googleUser});
  @override
  List<Object> get props => [phoneNumber, countryCode, userId, googleUser];
}

class ResendOtpEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class VerifyOtpEvent extends AuthenticationEvent {
  final String otp;
  final String phoneNumber;
  final String countryCode;
  final String userId;
  final FirebaseUser googleUser;

  VerifyOtpEvent(
      {this.phoneNumber,
      this.countryCode,
      this.userId,
      this.otp,
      this.googleUser});
  @override
  List<Object> get props => [otp, phoneNumber, countryCode, userId, googleUser];
}

class OtpSendEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final FirebaseUser user;
  final FirebaseUser googleUser;
  final String phoneNumber;
  final String countryCode;
  final String userId;
  LoggedIn(this.user, this.googleUser, this.phoneNumber, this.countryCode,
      this.userId);
  @override
  String toString() => 'LoggedIn';

  @override
  List<Object> get props =>
      [user, googleUser, phoneNumber, countryCode, userId];
}

class PickedProfilePicture extends AuthenticationEvent {
  final File file;
  PickedProfilePicture(this.file);
  @override
  String toString() => 'PickedProfilePicture';

  @override
  List<Object> get props => [file];
}

class SaveUserProfile extends AuthenticationEvent {
  final File profileImage;
  final UserObject user;
  SaveUserProfile(this.profileImage, this.user);
  @override
  String toString() => 'SaveUserProfile';

  @override
  List<Object> get props => [profileImage, user];
}

class ClickedLogout extends AuthenticationEvent {
  @override
  String toString() => 'ClickedLogout';

  @override
  List<Object> get props => [];
}

class AuthExceptionEvent extends AuthenticationEvent {
  final String message;
  AuthExceptionEvent(this.message);
  @override
  List<Object> get props => [message];
}
