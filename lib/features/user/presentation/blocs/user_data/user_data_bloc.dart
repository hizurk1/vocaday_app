import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_user_data.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final GetUserDataUsecase getUserDataUsecase;
  final String uid;
  late StreamSubscription _userDataStream;

  UserDataBloc(this.getUserDataUsecase, this.uid)
      : super(UserDataEmptyState()) {
    _userDataStream = getUserDataUsecase(uid).listen((userData) {
      if (userData != null) {
        add(GetUserDataEvent(userData));
      }
    });

    on<GetUserDataEvent>((event, emit) {
      emit(UserDataLoadedState(event.entity));
    });
  }

  @override
  Future<void> close() {
    _userDataStream.cancel();
    return super.close();
  }
}
