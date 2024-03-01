part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User? user;
  final bool? isAuthenticating;

  const AuthState(this.user, this.isAuthenticating);

  AuthState copyWith({
    User? user,
    bool? isAuthenticating,
  }) {
    return AuthState(
      user ?? this.user,
      isAuthenticating ?? this.isAuthenticating,
    );
  }

  @override
  List<Object?> get props => [user, isAuthenticating];
}

final class UnauthenticatedState extends AuthState {
  const UnauthenticatedState() : super(null, false);
}

final class AuthenticatedState extends AuthState {
  const AuthenticatedState(User user) : super(user, false);
}
