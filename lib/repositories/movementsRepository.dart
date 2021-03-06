import 'dart:async';

import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/models/vehicle_type.dart';
import 'package:covid_app/providers/movementsProvider.dart';
import 'package:covid_app/providers/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class MovementsRepository {
  BaseMovementsProvider _movementsProvider = MovementsProvider();

  Future<void> saveUserMovement(UserMovement userMovement) =>
      _movementsProvider.saveUserMovement(userMovement);

  Future<List<UserMovement>> fetchUserMovements(String userId) =>
      _movementsProvider.fetchUserMovements(userId);

  Future<List<UserMovement>> fetchUserMovementsForRange(
          {String userId, DateTime dateTimeFrom, DateTime dateTimeTo}) =>
      _movementsProvider.fetchUserMovementsBetween(
        userId,
        dateTimeFrom,
        dateTimeTo,
      );

  Future<List<VehicleType>> fetchVehicleTypes() =>
      _movementsProvider.fetchVehicleTypes();

  Future<VehicleType> fetchVehicleTypeById(String id) =>
      _movementsProvider.fetchVehicleTypeById(id);

  StreamSubscription<Event> listenToStartTrip(AppUser appUser) =>
      _movementsProvider.listenToStartTrip(appUser);

  StreamSubscription<Event> listenToEndTrip(AppUser appUser) =>
      _movementsProvider.listenToEndTrip(appUser);
}
