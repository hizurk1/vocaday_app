part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  final User? user;

  const AuthState(this.user);

  @override
  List<Object?> get props => [user];
}

final class UnknownAuthState extends AuthState {
  const UnknownAuthState() : super(null);
}

final class UnauthenticatedState extends AuthState {
  const UnauthenticatedState() : super(null);
}

final class AuthenticatedState extends AuthState {
  const AuthenticatedState(super.user);
}
