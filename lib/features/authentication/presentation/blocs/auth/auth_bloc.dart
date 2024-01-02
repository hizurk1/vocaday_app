import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/managers/navigation.dart';
import '../../../domain/usecases/auth_state_changed.dart';
import '../../../domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthStateChangedUsecase authStateChangedUsecase;
  final SignOutUsecase signOutUsecase;
  late StreamSubscription _streamSubscription;

  AuthBloc(this.authStateChangedUsecase, this.signOutUsecase)
      : super(const UnauthenticatedState()) {
    _streamSubscription = authStateChangedUsecase.user.listen((user) {
      add(AuthStateChangedEvent(user));
    });

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
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
