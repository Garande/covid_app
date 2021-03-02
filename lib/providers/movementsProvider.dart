import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/trip.dart';
import 'package:covid_app/models/driver.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/providers/provider.dart';
import 'package:covid_app/utils/Paths.dart';
// import 'package:firebase_database/firebase_database.dart';

final String movementsCollectionsPath = '';
final String tripsCollectionsPath = '';
final String driverCollectionsPath = '';

class MovementsProvider extends BaseMovementsProvider {
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
        .where('creationDateTimeMillis',
            isGreaterThanOrEqualTo: dateTimeFrom.millisecondsSinceEpoch)
        .where('creationDateTimeMills',
            isLessThanOrEqualTo: dateTimeTo.millisecondsSinceEpoch)
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
}
