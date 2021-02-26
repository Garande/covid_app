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
}
