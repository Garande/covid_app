part of 'movements_bloc.dart';

abstract class MovementsState extends Equatable {
  MovementsState();
}

class MovementsInitial extends MovementsState {
  @override
  List<Object> get props => [];
}

class Uploading extends MovementsState {
  @override
  String toString() => 'Uploading';

  @override
  List<Object> get props => [];
}

class UploadComplete extends MovementsState {
  @override
  String toString() => 'UploadComplete';

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
