import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/utils/util_functions.dart';
import '../../../../app/widgets/widgets.dart';
import '../blocs/sign_in/sign_in_bloc.dart';
import '../widgets/auth_card_container.dart';
import 'reset_password_bottom_sheet.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with AutomaticKeepAliveClientMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _onSignInButton(SignInState state) {
    if (state is! SignInLoadingState) {
      UtilFunction.unFocusTextField();
      context.read<SignInBloc>().add(
            RequestSignInEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  _onSignInGoogleButton(SignInState state) {
    if (state is! SignInLoadingState) {
      context.read<SignInBloc>().add(RequestSignInGoogleEvent());
    }
  }

  _forgotPasswordBottomSheet() {
    context.showBottomSheet(
      child: const ResetPasswordBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: AuthCardContainerWidget(
                      child: BlocConsumer<SignInBloc, SignInState>(
                        listener: (context, state) {
                          if (state is SignInErrorState) {
                            Navigators().showMessage(
                              state.message,
                              type: MessageType.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextCustom(
                                LocaleKeys.auth_welcome.tr(),
                                style: context.textStyle.titleM.bw,
                              ),
                              const Gap(height: 30),
                              BorderTextField(
                                controller: _emailController,
                                icon: Assets.icons.email,
                                inputType: TextInputType.emailAddress,
                                hintText: LocaleKeys.auth_enter_email.tr(),
                              ),
                              const Gap(height: 20),
                              BorderTextField(
                                controller: _passwordController,
                                icon: Assets.icons.lock,
                                inputType: TextInputType.visiblePassword,
                                isPasswordField: true,
                                hintText: LocaleKeys.auth_enter_password.tr(),
                              ),
                              if (state is SignInErrorState) ...[
                                const Gap(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: _forgotPasswordBottomSheet,
                                    child: TextCustom(
                                      LocaleKeys.auth_forgot_password.tr(),
                                      style: context.textStyle.bodyS.grey,
                                    ),
                                  ),
                                ),
                              ],
                              const Gap(height: 20),
                              PushableButton(
                                onPressed: () => _onSignInButton(state),
                                type: state is SignInLoadingState
                                    ? PushableButtonType.disable
                                    : PushableButtonType.primary,
                                child: state is SignInLoadingState
                                    ? const LoadingIndicatorWidget()
                                    : TextCustom(
                                        LocaleKeys.auth_sign_in.tr(),
                                        style: context.textStyle.bodyS.white,
                                      ),
                              ),
                              const Gap(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextCustom(
                                    LocaleKeys.auth_or_sign_in_with.tr(),
                                    style: context.textStyle.bodyS.grey,
                                  ),
                                  GestureDetector(
                                    onTap: () => _onSignInGoogleButton(state),
                                    child: Card(
                                      shape: const CircleBorder(),
                                      color:
                                          context.theme.scaffoldBackgroundColor,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.h,
                                          vertical: 5.w,
                                        ),
                                        child: SvgPicture.asset(
                                          Assets.icons.google,
                                          height: 30.h,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
