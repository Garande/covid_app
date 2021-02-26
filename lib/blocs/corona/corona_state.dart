part of 'corona_bloc.dart';

@immutable
abstract class CoronaState extends Equatable {
  const CoronaState();
}

class Uninitialized extends CoronaState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object> get props => [];
}

class TimeoutException extends CoronaState implements Exception {
  final String message = 'Server timeout';
  @override
  List<Object> get props => [message];
}

class ServerException extends CoronaState implements Exception {
  final String message = 'Server busy';
  @override
  List<Object> get props => [message];
}

class ServerErrorException extends CoronaState implements Exception {
  final String message;

  ServerErrorException(this.message);
  @override
  List<Object> get props => [message];
}
