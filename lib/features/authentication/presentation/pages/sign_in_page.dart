import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/app_asset.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/border_text_field.dart';
import '../../../../app/widgets/gap.dart';
import '../../../../app/widgets/loading_indicator.dart';
import '../../../../app/widgets/pushable_button.dart';
import '../../../../app/widgets/text.dart';
import '../blocs/sign_in/sign_in_bloc.dart';
import '../widgets/auth_card_container.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _onSignInButton(SignInState state) {
    if (state is! SignInLoadingState) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.screenHeight - context.screenHeight * 0.13645,
          child: Stack(
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
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          const Gap(height: 30),
                          BorderTextField(
                            controller: _emailController,
                            icon: AppAssets.emailIcon,
                            inputType: TextInputType.emailAddress,
                            hintText: LocaleKeys.auth_enter_email.tr(),
                          ),
                          const Gap(height: 20),
                          BorderTextField(
                            controller: _passwordController,
                            icon: AppAssets.passwordIcon,
                            inputType: TextInputType.visiblePassword,
                            isPasswordField: true,
                            hintText: LocaleKeys.auth_enter_password.tr(),
                          ),
                          if (state is SignInErrorState) ...[
                            const Gap(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: TextCustom(
                                  LocaleKeys.auth_forgot_password.tr(),
                                  color:
                                      context.theme.hintColor.withOpacity(.45),
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                          ),
                          const Gap(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextCustom(
                                LocaleKeys.auth_or_sign_in_with.tr(),
                                color: context.theme.hintColor.withOpacity(.45),
                              ),
                              GestureDetector(
                                onTap: () => _onSignInGoogleButton(state),
                                child: Card(
                                  shape: const CircleBorder(),
                                  color: context.theme.scaffoldBackgroundColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: SvgPicture.asset(
                                      AppAssets.googleIcon,
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
        ),
      ),
    );
  }
}
