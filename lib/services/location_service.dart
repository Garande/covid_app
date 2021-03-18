// import 'package:google_maps_webservice/directions.dart';

import 'dart:async';

import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/models/user_summary.dart';
import 'package:covid_app/repositories/authenticationRepository.dart';
import 'package:covid_app/repositories/coronaRepository.dart';
import 'package:covid_app/repositories/movementsRepository.dart';
import 'package:covid_app/repositories/userRepository.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/constants.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
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

  CoronaRepository coronaRepository = CoronaRepository();

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

  void listenGeoFire(AppUser appUser, LatLng latLng) {
    try {
      Geofire.queryAtLocation(latLng.latitude, latLng.longitude, 5)
          .listen((map) async {
        // printLog(map);
        if (map != null) {
          var callBack = map['callBack'];

          switch (callBack) {
            case Geofire.onKeyEntered:
              String dataKey = map["key"];
              UserSummary userSummary =
                  await coronaRepository.fetchUserSummary(dataKey);
              if (userSummary != null &&
                  (userSummary.officialCovidTestStatus ==
                          CovidResult.POSITIVE ||
                      userSummary.officialCovidTestStatus ==
                          CovidResult.SYMPTOMATIC ||
                      userSummary.selfCovidTestStatus == CovidResult.POSITIVE ||
                      userSummary.selfCovidTestStatus ==
                          CovidResult.SYMPTOMATIC)) {
                AppUser appUser = await userDataRepository
                    .getUserByUserId(userSummary.userId);
                //show Notification
              }
              break;

            case Geofire.onKeyExited:
              // keysRetrieved.remove(map["key"]);
              break;

            case Geofire.onKeyMoved:
              break;

            case Geofire.onGeoQueryReady:
              break;
          }
        }
      }).onError((error) {
        printLog(error);
      });
    } on PlatformException {}
  }

  void listenToUserLocation() async {
    appUser = await getCurrentUser();

    String geoFireLocationPath = "ContactTrackerGeofire";
    Geofire.initialize(geoFireLocationPath);

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

        bool geoResponse = await Geofire.setLocation(
            appUser.userId, locationData.latitude, locationData.longitude);
        if (geoResponse) {
          // printLog('Updated Location... ');
        }
      }
    });
  }
}
