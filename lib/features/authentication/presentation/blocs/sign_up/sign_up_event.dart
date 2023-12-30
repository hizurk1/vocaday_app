part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class RequestSignUpEvent extends SignUpEvent {
  final String email;
  final String password;
  final String rePassword;

  const RequestSignUpEvent({
    required this.email,
    required this.password,
    required this.rePassword,
  });

  @override
  List<Object> get props => [email, password, rePassword];
}
