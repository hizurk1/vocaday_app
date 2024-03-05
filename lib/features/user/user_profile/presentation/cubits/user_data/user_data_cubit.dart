import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../app/managers/navigation.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/utils/validator.dart';
import '../../../../../../core/extensions/string.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/add_attendance_date.dart';
import '../../../domain/usecases/get_user_data.dart';
import '../../../domain/usecases/update_user_profile.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final GetUserDataUsecase getUserDataUsecase;
  final UpdateUserProfileUsecase updateUserProfileUsecase;
  final AddAttendanceDateUsecase addAttendanceDateUsecase;
  StreamSubscription? _streamSubscription;

  UserDataCubit(
    this.getUserDataUsecase,
    this.updateUserProfileUsecase,
    this.addAttendanceDateUsecase,
  ) : super(UserDataEmptyState());

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  void initDataStream(String? uid) {
    if (uid.isNotNullOrEmpty) {
      _streamSubscription ??= getUserDataUsecase(uid!).listen((entity) {
        if (entity != null) {
          emit(UserDataLoadedState(entity));
        }
      });
    }
  }

  void cancelDataStream() {
    emit(UserDataEmptyState());
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  Future<void> updateUserProfile(UserEntity entity, XFile? image) async {
    if (entity.name.isEmpty) {
      Navigators().showMessage(
        LocaleKeys.profile_no_empty_display_name.tr(),
        type: MessageType.error,
      );
    } else if (entity.phone.isNotNullOrEmpty &&
        !Validator.validatePhoneNumber(entity.phone!)) {
      Navigators().showMessage(
        LocaleKeys.profile_invalid_phone_number.tr(),
        type: MessageType.error,
      );
    } else if ((state as UserDataLoadedState).entity == entity &&
        image == null) {
      Navigators().popDialog();
      Navigators().showMessage(
        LocaleKeys.profile_everything_is_up_to_date.tr(),
        type: MessageType.success,
      );
    } else {
      final result = await updateUserProfileUsecase((entity, image));

      result.fold(
        (failure) {
          Navigators().showMessage(
            failure.message,
            type: MessageType.error,
            duration: 5,
          );
        },
        (_) {
          Navigators().showMessage(
            LocaleKeys.profile_update_success.tr(),
            type: MessageType.success,
          );
          Navigators().popDialog();
        },
      );
    }
  }

  Future<void> addAttendanceDate(String uid, List<DateTime> attendance) async {
    if (attendance.isEmpty) return;

    final result = await addAttendanceDateUsecase((uid, attendance));

    result.fold(
      (failure) {
        Navigators().showMessage(failure.message, type: MessageType.error);
      },
      (res) {
        Navigators().showMessage(
          LocaleKeys.home_check_in_success.tr(),
          type: MessageType.success,
        );
      },
    );
  }
}
