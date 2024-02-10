part of 'user_data_cubit.dart';

sealed class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

final class UserDataEmptyState extends UserDataState {}

final class UserDataLoadingState extends UserDataState {}

final class UserDataLoadedState extends UserDataState {
  final UserEntity entity;

  const UserDataLoadedState(this.entity);

  @override
  List<Object> get props => [entity];
}

final class UserDataErrorState extends UserDataState {
  final String message;

  const UserDataErrorState(this.message);
  @override
  List<Object> get props => [message];
}
