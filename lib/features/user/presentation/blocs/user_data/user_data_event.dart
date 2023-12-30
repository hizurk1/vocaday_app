part of 'user_data_bloc.dart';

sealed class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

final class GetUserDataEvent extends UserDataEvent {
  final UserEntity entity;

  const GetUserDataEvent(this.entity);

  @override
  List<Object> get props => [entity];
}
