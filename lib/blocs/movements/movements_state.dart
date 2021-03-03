part of 'movements_bloc.dart';

abstract class MovementsState extends Equatable {
  MovementsState();
}

class MovementsInitial extends MovementsState {
  @override
  List<Object> get props => [];
}

class UploadingProfile extends MovementsState {
  @override
  String toString() => 'UploadingProfile';

  @override
  List<Object> get props => [];
}

class ProfileUpdateComplete extends MovementsState {
  @override
  String toString() => 'ProfileUpdateComplete';

  @override
  List<Object> get props => [];
}

class UploadException extends MovementsState {
  final dynamic message;
  UploadException(this.message);

  @override
  String toString() => 'UploadException';

  @override
  List<Object> get props => [message];
}
