import 'package:bloc/bloc.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/repositories/movementsRepository.dart';
import 'package:equatable/equatable.dart';

part 'movements_state.dart';
part 'movements_event.dart';

class MovementsBloc extends Bloc<MovementsEvent, MovementsState> {
  MovementsBloc() : super(null);

  MovementsRepository _movementsRepository = MovementsRepository();

  @override
  MovementsState get initialState => MovementsInitial();

  @override
  Stream<MovementsState> mapEventToState(MovementsEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
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
}
