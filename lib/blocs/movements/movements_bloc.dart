import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/driver.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/repositories/authenticationRepository.dart';
import 'package:covid_app/repositories/movementsRepository.dart';
import 'package:covid_app/repositories/storageRepository.dart';
import 'package:covid_app/repositories/userRepository.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:equatable/equatable.dart';
import 'package:covid_app/models/vehicle_type.dart';

part 'movements_state.dart';
part 'movements_event.dart';

class MovementsBloc extends Bloc<MovementsEvent, MovementsState> {
  MovementsBloc() : super(null);

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();

  MovementsRepository _movementsRepository = MovementsRepository();

  @override
  MovementsState get initialState => MovementsInitial();

  @override
  Stream<MovementsState> mapEventToState(MovementsEvent event) async* {
    if (event is UpdateProfile)
      yield* mapUpdateProfileToState(event.profileImage, event.user);
    else if (event is UpdateDriver)
      yield* mapUpdateDriverToState(event.appUser, event.driver);
  }

  Stream<MovementsState> mapUpdateProfileToState(
      File profileImage, AppUser user) async* {
    yield Uploading();
    try {
      if (profileImage != null) {
        String photoUrl = await storageRepository.uploadImage(
            profileImage, Paths.profilePicturePath);

        user.photoUrl = photoUrl;
      }
      await userDataRepository.saveUserProfileDetails(user);
      yield UploadComplete(); //redirect to home page
    } catch (e) {
      printLog(e);
      yield UploadException(e.toString());
    }
  }

  Future<void> saveUserMovement(UserMovement userMovement) {
    return _movementsRepository.saveUserMovement(userMovement);
  }

  Future<List<UserMovement>> fetchUserMovements(String userId) =>
      _movementsRepository.fetchUserMovements(userId);

  Future<List<UserMovement>> fetchUserMovementsForRange({
    String userId,
    DateTime dateTime1,
    DateTime dateTime2,
  }) =>
      _movementsRepository.fetchUserMovementsForRange(
        userId: userId,
        dateTimeFrom: dateTime1,
        dateTimeTo: dateTime2,
      );

  Future<List<VehicleType>> fetchVehicleTypes() =>
      _movementsRepository.fetchVehicleTypes();

  Stream<MovementsState> mapUpdateDriverToState(
      AppUser appUser, Driver driver) async* {
    yield Uploading();
    try {
      await userDataRepository.saveDriver(driver);
      await userDataRepository.saveUserProfileDetails(appUser);
      yield UploadComplete(); //redirect to home page
    } catch (e) {
      printLog(e);
      yield UploadException(e.toString());
    }
  }
}
