import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/translations/translations.dart';
import '../../../domain/usecases/sign_in_with_email_password.dart';
import '../../../domain/usecases/sign_in_with_google.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInWithEmailPasswordUsecase signInWithEmailPasswordUsecase;
  final SignInWithGoogleUsecase signInWithGoogleUsecase;

  SignInBloc(
    this.signInWithEmailPasswordUsecase,
    this.signInWithGoogleUsecase,
  ) : super(SignInInitialState()) {
    on<RequestSignInEvent>(_onRequestSignInEvent);
    on<RequestSignInGoogleEvent>(_onRequestSignInGoogleEvent);
  }

  Future<void> _onRequestSignInGoogleEvent(
    RequestSignInGoogleEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoadingState());

    final result = await signInWithGoogleUsecase();

    result.fold(
      (failure) => emit(SignInErrorState(failure.message)),
      (entity) => emit(SignInSuccessState()),
    );
  }

  Future<void> _onRequestSignInEvent(
    RequestSignInEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoadingState());
    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      final result = await signInWithEmailPasswordUsecase(
        (event.email, event.password),
      );

      result.fold(
        (failure) {
          emit(SignInErrorState(failure.message));
        },
        (_) => emit(SignInSuccessState()),
      );
    } else {
      emit(SignInErrorState(
        LocaleKeys.auth_please_enter_and_password.tr(),
      ));
    }
  }
}
