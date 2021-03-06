// import 'package:google_maps_webservice/directions.dart';

import 'dart:async';

import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/repositories/authenticationRepository.dart';
import 'package:covid_app/repositories/movementsRepository.dart';
import 'package:covid_app/repositories/userRepository.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class LocationService {
  factory LocationService() => _instance;

  LocationService._internal();

  static final _instance = LocationService._internal();

  Location location = Location();

  MovementsRepository movementsRepository = MovementsRepository();
  AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  UserDataRepository userDataRepository = UserDataRepository();

  // MovementsBloc _movementsBloc = MovementsBloc();

  AppUser appUser;

  UserMovement previousLocationData;

  StreamController<UserMovement> _locationController =
      StreamController<UserMovement>();

  Stream<UserMovement> get locationStream => _locationController.stream;

  Future<AppUser> getCurrentUser() async {
    User firebaseUser = authenticationRepository.getCurrentUser();
    if (firebaseUser != null) {
      AppUser user =
          await userDataRepository.getUserByLoginId(firebaseUser.uid);
      return user;
    }
    return null;
  }

  void listenToUserLocation() async {
    appUser = await getCurrentUser();

    location.onLocationChanged.listen((locationData) async {
      // printLog('Listening to location changes');
      double distanceInMeters;
      if (previousLocationData != null) {
        final Distance distance = new Distance();
        LatLng loc1 = new LatLng(
            previousLocationData.latitude, previousLocationData.longitude);
        LatLng loc2 = new LatLng(locationData.latitude, locationData.longitude);

        distanceInMeters = distance(loc1, loc2);
        // printLog(distanceInMeters);
      }

      int timestamp = new DateTime.now().millisecondsSinceEpoch;

      _locationController.add(
        UserMovement(
            latitude: locationData.latitude,
            longitude: locationData.longitude,
            creationDateTimeMillis: timestamp),
      );

      if (appUser != null) {
        UserMovement movement = new UserMovement();
        movement.latitude = locationData.latitude;
        movement.longitude = locationData.longitude;
        movement.creationDateTimeMillis = timestamp;
        movement.userId = appUser.userId;
        movement.id = Paths.generateFirestoreDbKey(
          [appUser.userId, 'MOV'],
          timestamp,
        );

        // Save location data
        if (distanceInMeters != null) {
          if (distanceInMeters >= 10.0) {
            movementsRepository.saveUserMovement(movement);
          }
        } else {
          movementsRepository.saveUserMovement(movement);
        }

        previousLocationData = movement;
      }
    });
  }
}
