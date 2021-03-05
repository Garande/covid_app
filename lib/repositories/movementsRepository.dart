import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/models/vehicle_type.dart';
import 'package:covid_app/providers/movementsProvider.dart';
import 'package:covid_app/providers/provider.dart';

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
}
