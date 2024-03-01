import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/managers/navigation.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/utils/validator.dart';
import '../../../domain/usecases/auth_state_changed.dart';
import '../../../domain/usecases/change_password.dart';
import '../../../domain/usecases/re_authentication.dart';
import '../../../domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthStateChangedUsecase authStateChangedUsecase;
  final SignOutUsecase signOutUsecase;
  final ReAuthenticationUsecase reAuthenticationUsecase;
  final ChangePasswordUsecase changePasswordUsecase;

  StreamSubscription? _streamSubscription;

  AuthBloc(
    this.authStateChangedUsecase,
    this.signOutUsecase,
    this.changePasswordUsecase,
    this.reAuthenticationUsecase,
  ) : super(const UnauthenticatedState()) {
    on<AuthStateChangedEvent>((event, emit) {
      if (event.user != null) {
        emit(AuthenticatedState(event.user!));
      } else {
        emit(const UnauthenticatedState());
      }
    });

    on<RequestSignOutEvent>((event, emit) async {
      final result = await signOutUsecase();
      result.fold(
        (failure) => Navigators().showMessage(
          failure.message,
          type: MessageType.error,
        ),
        (_) => emit(const UnauthenticatedState()),
      );
    });

    on<RequestChangePasswordEvent>((event, emit) async {
      emit(state.copyWith(isAuthenticating: true));

      final reAuth =
          await reAuthenticationUsecase((event.email, event.currPassword));
      await reAuth.fold(
        (failure) => Navigators().showMessage(
          failure.message,
          type: MessageType.error,
        ),
        (_) async {
          if (!Validator.validatePassword(event.newPassword)) {
            Navigators().showMessage(
              LocaleKeys.auth_invalid_password.tr(),
              type: MessageType.error,
            );
          } else if (event.newPassword != event.confirmPassword) {
            Navigators().showMessage(
              LocaleKeys.auth_password_does_not_match.tr(),
              type: MessageType.error,
            );
          } else {
            final result = await changePasswordUsecase(event.newPassword);
            await result.fold(
              (failure) => Navigators().showMessage(
                failure.message,
                type: MessageType.error,
              ),
              (_) async {
                await Navigators().popDialog(); // Pop changepasswordpage
                add(RequestSignOutEvent()); // SignOut & navigate
                await Navigators().showDialogWithButton(
                  title: LocaleKeys.auth_change_password_success.tr(),
                  subtitle: LocaleKeys.auth_please_re_login.tr(),
                  showCancel: false,
                );
              },
            );
          }
        },
      );
      emit(state.copyWith(isAuthenticating: false));
    });
  }

  void initAuthStream() {
    _streamSubscription ??= authStateChangedUsecase.user.listen((user) {
      add(AuthStateChangedEvent(user));
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
