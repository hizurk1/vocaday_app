import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/managers/navigation.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../core/extensions/string.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_user_data.dart';
import '../../../domain/usecases/update_user_profile.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final GetUserDataUsecase getUserDataUsecase;
  final UpdateUserProfileUsecase updateUserProfileUsecase;
  StreamSubscription? _streamSubscription;

  UserDataCubit(
    this.getUserDataUsecase,
    this.updateUserProfileUsecase,
  ) : super(UserDataEmptyState());

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

  Future<void> updateUserProfile(UserEntity entity) async {
    emit(UserDataLoadingState());

    final result = await updateUserProfileUsecase(entity);

    result.fold(
      (failure) => emit(UserDataErrorState(failure.message)),
      (_) {
        Navigators().showMessage(
          LocaleKeys.profile_update_success.tr(),
          type: MessageType.success,
        );
        emit(UserDataLoadedState(entity));
      },
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
