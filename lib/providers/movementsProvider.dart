import 'dart:async';

import 'package:algolia/algolia.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/trip.dart';
import 'package:covid_app/models/driver.dart';
import 'package:covid_app/models/trip_summary.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/models/vehicle_type.dart';
import 'package:covid_app/providers/provider.dart';
import 'package:covid_app/providers/userDataProvider.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:google_maps_webservice/directions.dart';
// import 'package:firebase_database/firebase_database.dart';

final String movementsCollectionsPath = '/MAIN/ACTIVITIES/USER_MOVEMENTS';
final String tripsCollectionsPath = '/MAIN/ACTIVITIES/TRIPS';
final String driverCollectionsPath = '';
final String vehicleTypesCollectionsPaths = '/SYSTEM/MAIN/vehicleTypes';
final String onGoingTripsPath = 'onGoingTrips/users';

class MovementsProvider extends BaseMovementsProvider {
  BaseUserDataProvider _userDataProvider = UserDataProvider();
  @override
  Future<UserMovement> fetchUserLastMovement(String userId) {
    // TODO: implement fetchUserLastMovement
    throw UnimplementedError();
  }

  @override
  Future<List<UserMovement>> fetchUserMovements(String userId) {
    // TODO: implement fetchUserMovements
    throw UnimplementedError();
  }

  @override
  Future<void> saveUserMovement(UserMovement userMovement) {
    if (userMovement.id == null || userMovement.id.isEmpty) {
      userMovement.id = Paths.generateFirestoreDbKey(
          [userMovement.userId, 'MOV'],
          new DateTime.now().millisecondsSinceEpoch);
    }
    return Paths.firestoreDb
        .collection(movementsCollectionsPath)
        .doc(userMovement.id)
        .set(userMovement.toJson(), SetOptions(merge: true));
  }

  @override
  Future<List<UserMovement>> fetchUserMovementsBetween(
      String userId, DateTime dateTimeFrom, DateTime dateTimeTo) {
    return Paths.firestoreDb
        .collection(movementsCollectionsPath)
        .where('userId', isEqualTo: userId)
        .orderBy('creationDateTimeMillis', descending: true)
        .where('creationDateTimeMillis',
            isGreaterThanOrEqualTo: dateTimeFrom.millisecondsSinceEpoch)
        .where('creationDateTimeMillis',
            isLessThanOrEqualTo: dateTimeTo.millisecondsSinceEpoch)
        .limit(100)
        .get()
        .then(
          (snapshot) => snapshot.docs
              .map((doc) => UserMovement.fromMap(doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> boardVehicle(Trip trip) {
    return Paths.firestoreDb.collection(driverCollectionsPath).doc(trip.id).set(
          trip.toJson(),
          SetOptions(merge: true),
        );
  }

  @override
  Future<Driver> fetchDriverInfo(String driverId) {
    return Paths.firestoreDb
        .collection(driverCollectionsPath)
        .doc(driverId)
        .get()
        .then(
          (doc) => Driver.fromJson(doc.data()),
        );
  }

  @override
  Future<Trip> fetchTripFromId(String id) {
    return Paths.firestoreDb
        .collection(tripsCollectionsPath)
        .doc(id)
        .get()
        .then(
          (snapshot) => Trip.fromJson(snapshot.data()),
        );
  }

  @override
  Future<Trip> fetchTripInfo(String driverId, String userId) {
    return Paths.firestoreDb
        .collection(tripsCollectionsPath)
        .where('driverId', isEqualTo: driverId)
        .where('userId', isEqualTo: userId)
        .orderBy('creationDateTimeMillis', descending: true)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs
            .map(
              (doc) => Trip.fromJson(
                doc.data(),
              ),
            )
            .toList()[0]);
  }

  @override
  Future<void> saveDriverInfo(Driver driver) {
    return Paths.firestoreDb
        .collection(driverCollectionsPath)
        .doc(driver.userId)
        .set(
          driver.toJson(),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> updateTripInfo(Trip trip) {
    return Paths.firestoreDb.collection(tripsCollectionsPath).doc(trip.id).set(
          trip.toJson(),
          SetOptions(merge: true),
        );
  }

  void listen(AppUser appUser) {
    // StreamSubscription subscription = FirebaseDatabase.instance.reference().child('/trips/${appUser.userId}').onChildAdded.listen((e) => e.snapshot.value)
  }

  @override
  Future<VehicleType> fetchVehicleTypeById(String id) {
    // VehicleType.bus
    return Paths.firestoreDb
        .collection(vehicleTypesCollectionsPaths)
        .doc(id)
        .get()
        .then(
          (snapshot) => VehicleType.fromJson(snapshot.data()),
        );
  }

  @override
  Future<List<VehicleType>> fetchVehicleTypes() {
    return Paths.firestoreDb
        .collection(vehicleTypesCollectionsPaths)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => VehicleType.fromJson(doc.data()))
            .toList());
  }

  @override
  StreamSubscription<Event> listenToStartTrip(AppUser appUser) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('onGoingTrips/users/${appUser.userId}');
    return databaseReference.onChildAdded.listen((Event event) async {
      var data = event.snapshot.value;
      Trip trip = Trip.fromJson(data);
      AppUser peerUser;
      if (trip.peerId != appUser.userId) {
        peerUser = await _userDataProvider.getUserByUserId(trip.peerId);
      } else {
        peerUser = await _userDataProvider.getUserByUserId(trip.userId);
      }

      TripSummary tripSummary = new TripSummary(appUser, peerUser, trip);

      return tripSummary;
    });
  }

  @override
  StreamSubscription<Event> listenToEndTrip(AppUser appUser) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('onGoingTrips/users/${appUser.userId}');

    return databaseReference.onChildRemoved.listen((Event event) async {
      var data = event.snapshot.value;
      Trip trip = Trip.fromJson(data);
      AppUser peerUser;
      if (trip.peerId != appUser.userId) {
        peerUser = await _userDataProvider.getUserByUserId(trip.peerId);
      } else {
        peerUser = await _userDataProvider.getUserByUserId(trip.userId);
      }

      TripSummary tripSummary = new TripSummary(appUser, peerUser, trip);

      return tripSummary;
    });
  }

  @override
  Future<void> endTrip(Trip trip) async {
    await Paths.firestoreDb
        .collection(tripsCollectionsPath)
        .doc(trip.id)
        .set(trip.toJson(), SetOptions(merge: true));

    /// notifify driver
    if (trip.peerId != null) {
      await FirebaseDatabase.instance
          .reference()
          .child(onGoingTripsPath + "/" + trip.peerId)
          .child(trip.id)
          .remove();
    }

    /// notifify user
    if (trip.userId != null) {
      await FirebaseDatabase.instance
          .reference()
          .child(onGoingTripsPath + "/" + trip.userId)
          .child(trip.id)
          .remove();
    }
  }

  @override
  Future<void> startTrip(Trip trip) async {
    await Paths.firestoreDb
        .collection(tripsCollectionsPath)
        .doc(trip.id)
        .set(trip.toJson(), SetOptions(merge: true));

    /// notifify driver
    if (trip.peerId != null) {
      await FirebaseDatabase.instance
          .reference()
          .child(onGoingTripsPath + "/" + trip.peerId)
          .child(trip.id)
          .set(trip.toJson());
    }

    /// notifify user
    if (trip.userId != null) {
      await FirebaseDatabase.instance
          .reference()
          .child(onGoingTripsPath + "/" + trip.userId)
          .child(trip.id)
          .set(trip.toJson());
    }
  }

  @override
  Future<List<AppUser>> searchUser(String searchText) async {
    Algolia algolia = AlgoliaKeys.algolia;
    AlgoliaQuery query =
        algolia.instance.index('schools').search(searchText).setHitsPerPage(5);

    AlgoliaQuerySnapshot snap = await query.getObjects();

    List<AppUser> results = [];
    for (AlgoliaObjectSnapshot objectSnapshot in snap.hits) {
      // print();
      results.add(
        new AppUser(
          address: objectSnapshot.data['address'],
          userId: objectSnapshot.objectID,
          name: objectSnapshot.data['name'],
          photoUrl: objectSnapshot.data['photoUrl'],
          phoneNumber: objectSnapshot.data['phoneNumber'],
        ),
      );
    }

    return results;
  }
}
