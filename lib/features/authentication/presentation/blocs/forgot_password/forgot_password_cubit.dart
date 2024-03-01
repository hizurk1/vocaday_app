import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/translations/translations.dart';
import '../../../../../app/utils/validator.dart';
import '../../../domain/usecases/send_code_to_email.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendCodeToEmailUsecase sendCodeToEmailUsecase;

  ForgotPasswordCubit(this.sendCodeToEmailUsecase)
      : super(ForgotPasswordInitialState());

  Future<void> sendCodeToEmail(String email) async {
    emit(ForgotPasswordLoadingState());

    if (email.isEmpty) {
      emit(ForgotPasswordErrorState(LocaleKeys.auth_enter_email.tr()));
      return;
    }
    if (!Validator.validateEmail(email)) {
      emit(ForgotPasswordErrorState(LocaleKeys.auth_invalid_email.tr()));
      return;
    }

    final result = await sendCodeToEmailUsecase(email);

    result.fold(
      (failure) => ForgotPasswordErrorState(failure.message),
      (_) => emit(ForgotPasswordSuccessState()),
    );
  }
}
