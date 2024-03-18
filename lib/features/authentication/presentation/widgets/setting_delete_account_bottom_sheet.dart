import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/constants/app_const.dart';
import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/widgets.dart';
import '../../../user/user_profile/domain/entities/user_entity.dart';
import '../../../user/user_profile/presentation/cubits/user_data/user_data_cubit.dart';
import '../../data/models/auth_model.dart';
import '../blocs/auth/auth_bloc.dart';

class SettingDeleteAccountBottomSheet extends StatelessWidget {
  SettingDeleteAccountBottomSheet({super.key});

  final ValueNotifier<String> inputNotifier = ValueNotifier("");

  _onDeleteAccount(BuildContext context, UserEntity entity) {
    if (inputNotifier.value.isEmpty) {
      Navigators().showMessage(
        LocaleKeys.auth_enter_current_password.tr(),
        type: MessageType.error,
        opacity: 1,
      );
    } else {
      context
          .read<AuthBloc>()
          .add(RequestDeleteAccountEvent(entity, inputNotifier.value.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
      selector: (state) => state is UserDataLoadedState ? state.entity : null,
      builder: (context, UserEntity? userEntity) {
        return DynamicBottomSheetCustom(
          showDragHandle: true,
          child: userEntity == null
              ? const LoadingIndicatorPage()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w)
                      .copyWith(bottom: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextCustom(
                        LocaleKeys.setting_delete_acc.tr(),
                        style: context.textStyle.titleS.bold.bw,
                      ),
                      const Gap(height: 5),
                      TextCustom(
                        LocaleKeys.auth_are_you_want_to_delete_acc.tr(
                          args: [userEntity.email],
                        ),
                        style: context.textStyle.bodyS.grey,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                      const Gap(height: 5),
                      TextCustom(
                        LocaleKeys.auth_enter_your_to_confirm_the_action.tr(
                          args: [
                            userEntity.method == SignInMethod.email.name
                                ? LocaleKeys.auth_password.tr()
                                : AppStringConst.email
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: context.textStyle.bodyS.grey,
                        maxLines: 2,
                      ),
                      const Gap(height: 20),
                      BorderTextField(
                        onChanged: (value) => inputNotifier.value = value,
                        icon: Assets.icons.lock,
                        inputType: TextInputType.visiblePassword,
                        isPasswordField: true,
                        hintText: userEntity.method == SignInMethod.email.name
                            ? LocaleKeys.auth_enter_current_password.tr()
                            : LocaleKeys.auth_enter_email.tr(),
                      ),
                      const Gap(height: 20),
                      PushableButton(
                        onPressed: () => _onDeleteAccount(context, userEntity),
                        text: LocaleKeys.common_accept.tr(),
                        type: PushableButtonType.accent,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
