import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/string.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_user_data.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final GetUserDataUsecase getUserDataUsecase;
  StreamSubscription? _streamSubscription;

  UserDataCubit(this.getUserDataUsecase) : super(UserDataEmptyState());

  void initDataStream(String? uid) {
    if (uid.isNotNullOrEmpty) {
      _streamSubscription ??= getUserDataUsecase(uid!).listen((entity) {
        if (entity != null) {
          emit(UserDataLoadedState(entity));
        }
      });
    }
  }

  void cancelDataStream() => _streamSubscription?.cancel();

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
