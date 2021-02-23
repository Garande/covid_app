part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object> get props => [];
}

class AuthInProgress extends AuthenticationState {
  @override
  String toString() => 'AuthInProgress';

  @override
  List<Object> get props => [];
}

class GoogleAuthenticated extends AuthenticationState {
  final User user;
  GoogleAuthenticated(this.user);
  @override
  String toString() => 'GoogleAuthenticated';

  @override
  List<Object> get props => [user];
}

class UnAuthenticated extends AuthenticationState {
  @override
  String toString() => 'UnAuthenticated';

  @override
  List<Object> get props => [];
}

class OtpSentState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class WaitingOtpVerificationState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class OtpVerifiedState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class OtpExceptionState extends AuthenticationState {
  final String message;
  OtpExceptionState({this.message});
  @override
  List<Object> get props => [message];
}

class Authenticated extends AuthenticationState {
  final User user;
  Authenticated(this.user);
  @override
  String toString() => 'Authenticated';

  @override
  List<Object> get props => [user];
}

class PreFillData extends AuthenticationState {
  final AppUser user;
  PreFillData(this.user);
  @override
  String toString() => 'PreFillData';

  @override
  List<Object> get props => [user];
}

class ReceivedProfilePicture extends AuthenticationState {
  final File file;
  ReceivedProfilePicture(this.file);
  @override
  String toString() => 'ReceivedProfilePicture';

  @override
  List<Object> get props => [file];
}

class ProfileUpdateInProgress extends AuthenticationState {
  @override
  String toString() => 'ProfileUpdateInProgress';

  @override
  List<Object> get props => [];
}

class ProfileUpdated extends AuthenticationState {
  @override
  String toString() => 'ProfileUpdated';

  @override
  List<Object> get props => [];
}

class ProfileComplete extends AuthenticationState {
  @override
  String toString() => 'ProfileComplete';

  @override
  List<Object> get props => [];
}

class AuthExceptionState extends AuthenticationState {
  final String message;
  AuthExceptionState({this.message});
  @override
  List<Object> get props => [message];
}

// class AuthenticationInitial extends AuthenticationState {
//   @override
//   List<Object> get props => [];
// }
