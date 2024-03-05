import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/send_code_to_email.dart';
import '../blocs/forgot_password/forgot_password_cubit.dart';

class ResetPasswordBottomSheet extends StatefulWidget {
  const ResetPasswordBottomSheet({super.key});

  @override
  State<ResetPasswordBottomSheet> createState() =>
      _ResetPasswordBottomSheetState();
}

class _ResetPasswordBottomSheetState extends State<ResetPasswordBottomSheet> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCodeToEmail(BuildContext context) async {
    await context
        .read<ForgotPasswordCubit>()
        .sendCodeToEmail(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(sl<SendCodeToEmailUsecase>()),
      child: Builder(builder: (context) {
        return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordErrorState) {
              Navigators().showMessage(
                state.message,
                type: MessageType.error,
                opacity: 1,
              );
            }
            if (state is ForgotPasswordSuccessState) {
              Navigators().popDialog();
              Navigators().showMessage(
                LocaleKeys.auth_we_sent_verfication_code_to_email.tr(
                  args: [_emailController.text.trim()],
                ),
                type: MessageType.success,
              );
            }
          },
          builder: (context, state) {
            return DynamicBottomSheetCustom(
              showAction: false,
              textTitle: LocaleKeys.auth_forgot_password.tr(),
              dismissable: false,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              children: [
                TextCustom(
                  LocaleKeys.auth_enter_email_to_reset_password.tr(),
                  style: context.textStyle.bodyM.grey,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
                const Gap(height: 20),
                BorderTextField(
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  hintText: LocaleKeys.auth_enter_email.tr(),
                  icon: Assets.icons.email,
                  maxLength: 30,
                ),
                const Gap(height: 20),
                PushableButton(
                  onPressed: () => _sendCodeToEmail(context),
                  text: LocaleKeys.common_next.tr(),
                  type: state is ForgotPasswordLoadingState
                      ? PushableButtonType.disable
                      : PushableButtonType.primary,
                  child: state is ForgotPasswordLoadingState
                      ? const LoadingIndicatorWidget()
                      : null,
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
