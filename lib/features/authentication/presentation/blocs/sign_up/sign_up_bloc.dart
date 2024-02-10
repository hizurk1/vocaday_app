import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/translations/translations.dart';
import '../../../../../app/utils/validator.dart';
import '../../../domain/entities/auth_entity.dart';
import '../../../domain/usecases/sign_up_with_email_password.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpWithEmailPasswordUsecase signUpWithEmailPasswordUsecase;

  SignUpBloc(this.signUpWithEmailPasswordUsecase)
      : super(SignUpInitialState()) {
    on<RequestSignUpEvent>((event, emit) async {
      emit(SignUpLoadingState());
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(SignUpErrorState(
          LocaleKeys.auth_please_enter_and_password.tr(),
        ));
      } else if (!Validator.validateEmail(event.email)) {
        emit(SignUpErrorState(
          LocaleKeys.auth_invalid_email.tr(),
        ));
      } else if (!Validator.validatePassword(event.password)) {
        emit(SignUpErrorState(
          LocaleKeys.auth_invalid_password.tr(),
        ));
      } else if (event.password != event.rePassword) {
        emit(SignUpErrorState(
          LocaleKeys.auth_password_does_not_match.tr(),
        ));
      } else {
        final result = await signUpWithEmailPasswordUsecase(
          (event.email, event.password),
        );

        result.fold(
          (failure) => emit(SignUpErrorState(failure.message)),
          (object) => emit(SignUpSuccessState(object)),
        );
      }
    });
  }
}
