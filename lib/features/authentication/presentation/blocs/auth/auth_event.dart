part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStateChangedEvent extends AuthEvent {
  final User? user;

  const AuthStateChangedEvent(this.user);

  @override
  List<Object?> get props => [user];
}

final class RequestChangePasswordEvent extends AuthEvent {
  final String email, currPassword, newPassword, confirmPassword;

  const RequestChangePasswordEvent(
    this.email,
    this.currPassword,
    this.newPassword,
    this.confirmPassword,
  );
}

final class RequestSignOutEvent extends AuthEvent {}

final class RequestDeleteAccountEvent extends AuthEvent {
  final UserEntity entity;
  final String password;

  const RequestDeleteAccountEvent(this.entity, this.password);
}
