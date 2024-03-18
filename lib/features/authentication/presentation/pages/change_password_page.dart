import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/utils/util_functions.dart';
import '../../../../app/widgets/widgets.dart';
import '../../../../core/extensions/build_context.dart';
import '../blocs/auth/auth_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onChangePassword(String email) {
    context.read<AuthBloc>().add(RequestChangePasswordEvent(
          email,
          _currentPassword.text.trim(),
          _newPassword.text.trim(),
          _confirmPassword.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.user != null) {
          return StatusBar(
            child: Scaffold(
              backgroundColor: context.backgroundColor,
              appBar: AppBarCustom(
                leading: _buildBackButton(),
                transparent: true,
              ),
              extendBodyBehindAppBar: true,
              body: _buildBody(
                state.user?.email ?? '',
                state.isAuthenticating ?? false,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildBody(String email, bool isAuthenticating) {
    return Stack(
      children: [
        SizedBox(
          height: context.screenHeight * 0.5,
          child: Center(
            child: SvgPicture.asset(
              Assets.images.computerPassword,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.screenHeight * 0.55,
              maxHeight: context.screenHeight,
            ),
            child: Container(
              width: context.screenWidth,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextCustom(
                      LocaleKeys.auth_change_password.tr(),
                      style: context.textStyle.titleL.bw.bold,
                    ),
                    const Gap(height: 10),
                    TextCustom(
                      LocaleKeys.auth_change_password_sub_title.tr(),
                      style: context.textStyle.bodyS.grey,
                    ),
                    const Gap(height: 30),
                    BorderTextField(
                      controller: _currentPassword,
                      inputType: TextInputType.visiblePassword,
                      hintText: LocaleKeys.auth_enter_current_password.tr(),
                      isPasswordField: true,
                      icon: Assets.icons.lock,
                      maxLength: 30,
                    ),
                    const Gap(height: 20),
                    BorderTextField(
                      controller: _newPassword,
                      inputType: TextInputType.visiblePassword,
                      hintText: LocaleKeys.auth_enter_new_password.tr(),
                      isPasswordField: true,
                      icon: Assets.icons.lock,
                      maxLength: 30,
                    ),
                    const Gap(height: 20),
                    BorderTextField(
                      controller: _confirmPassword,
                      inputType: TextInputType.visiblePassword,
                      hintText: LocaleKeys.auth_confirm_password.tr(),
                      isPasswordField: true,
                      icon: Assets.icons.lock,
                      maxLength: 30,
                    ),
                    const Gap(height: 30),
                    PushableButton(
                      onPressed: () {
                        if (!isAuthenticating) {
                          UtilFunction.unFocusTextField();
                          _onChangePassword(email);
                        }
                      },
                      text: LocaleKeys.common_next.tr(),
                      type: isAuthenticating
                          ? PushableButtonType.disable
                          : PushableButtonType.primary,
                      child: isAuthenticating
                          ? const LoadingIndicatorWidget()
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: BackButton(
        style: ButtonStyle(iconSize: MaterialStateProperty.all(24.r)),
      ),
    );
  }
}
