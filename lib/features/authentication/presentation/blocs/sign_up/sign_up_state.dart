part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitialState extends SignUpState {}

final class SignUpLoadingState extends SignUpState {}

final class SignUpSuccessState extends SignUpState {
  final AuthEntity authEntity;

  const SignUpSuccessState(this.authEntity);

  @override
  List<Object> get props => [authEntity];
}

final class SignUpErrorState extends SignUpState {
  final String message;

  const SignUpErrorState(this.message);

  @override
  List<Object> get props => [message];
}
