part of 'movements_bloc.dart';

abstract class MovementsEvent extends Equatable {
  MovementsEvent();
}

class UpdateProfile extends MovementsEvent {
  final File profileImage;
  final AppUser user;
  UpdateProfile(this.profileImage, this.user);
  @override
  String toString() => 'Update Profile';

  @override
  List<Object> get props => [profileImage, user];
}

class UpdateDriver extends MovementsEvent {
  final AppUser appUser;
  final Driver driver;

  UpdateDriver(this.appUser, this.driver);
  @override
  List<Object> get props => [appUser, driver];
}
