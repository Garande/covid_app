import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/driver.dart';
import 'package:covid_app/models/trip.dart';
import 'package:covid_app/models/trip_summary.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/repositories/authenticationRepository.dart';
import 'package:covid_app/repositories/movementsRepository.dart';
import 'package:covid_app/repositories/storageRepository.dart';
import 'package:covid_app/repositories/userRepository.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:equatable/equatable.dart';
import 'package:covid_app/models/vehicle_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'movements_state.dart';
part 'movements_event.dart';

class MovementsBloc extends Bloc<MovementsEvent, MovementsState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  final MovementsRepository movementsRepository;

  StreamSubscription<Event> onTripEndSubscription;

  StreamSubscription<Event> onTripStartSubscription;

  MovementsBloc(
    this.authenticationRepository,
    this.userDataRepository,
    this.storageRepository,
    this.movementsRepository,
  )   : assert(authenticationRepository != null),
        assert(userDataRepository != null),
        assert(movementsRepository != null),
        assert(storageRepository != null),
        super(null);

  @override
  MovementsState get initialState => MovementsInitial();

  dispose() {
    onTripEndSubscription.cancel();
    onTripStartSubscription.cancel();
  }

  @override
  Stream<MovementsState> mapEventToState(MovementsEvent event) async* {
    if (event is ListenToTrips)
      yield* mapListenToTripsToState();
    else if (event is UpdateProfile)
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
    return movementsRepository.saveUserMovement(userMovement);
  }

  Future<List<UserMovement>> fetchUserMovements(String userId) =>
      movementsRepository.fetchUserMovements(userId);

  Future<List<UserMovement>> fetchUserMovementsForRange({
    String userId,
    DateTime dateTime1,
    DateTime dateTime2,
  }) =>
      movementsRepository.fetchUserMovementsForRange(
        userId: userId,
        dateTimeFrom: dateTime1,
        dateTimeTo: dateTime2,
      );

  Future<List<VehicleType>> fetchVehicleTypes() =>
      movementsRepository.fetchVehicleTypes();

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

  Future<Driver> fetchDriverForId(String userId) =>
      userDataRepository.fetchDriverById(userId);

  Future<AppUser> getCurrentUser() async {
    User firebaseUser = authenticationRepository.getCurrentUser();
    if (firebaseUser != null) {
      AppUser user =
          await userDataRepository.getUserByLoginId(firebaseUser.uid);
      return user;
    }
    return null;
  }

  Stream getLiveEvents(AppUser appUser) {
    if (appUser != null) {
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .reference()
          .child('onGoingTrips/users/${appUser.userId}');

      return databaseReference.onChildAdded;
    }
    return null;
  }

  Stream<MovementsState> mapListenToTripsToState() async* {
    AppUser appUser = await getCurrentUser();
    if (appUser != null) {
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .reference()
          .child('onGoingTrips/users/${appUser.userId}');

      databaseReference.onChildAdded.listen((Event event) async* {
        var data = event.snapshot.value;
        Trip trip = Trip.fromJson(data);
        AppUser peerUser;
        if (trip.driverId != appUser.userId) {
          peerUser = await userDataRepository.getUserByUserId(trip.driverId);
        } else {
          peerUser = await userDataRepository.getUserByUserId(trip.userId);
        }

        TripSummary tripSummary = new TripSummary(appUser, peerUser, trip);
        printLog(tripSummary);

        yield TripInProgress(tripSummary);
        // return tripSummary;
      });

      // if (appUser != null)
      //   DatabaseReference databaseReference = FirebaseDatabase.instance
      //       .reference()
      //       .child('onGoingTrips/users/${appUser.userId}');

      //

      databaseReference.onChildRemoved.listen((Event event) async* {
        var data = event.snapshot.value;
        Trip trip = Trip.fromJson(data);
        AppUser peerUser;
        if (trip.driverId != appUser.userId) {
          peerUser = await userDataRepository.getUserByUserId(trip.driverId);
        } else {
          peerUser = await userDataRepository.getUserByUserId(trip.userId);
        }

        TripSummary tripSummary = new TripSummary(appUser, peerUser, trip);

        printLog('OFF:: ${tripSummary}');

        // return tripSummary;
        yield OffTrip(tripSummary);
      });
    }
  }
}
