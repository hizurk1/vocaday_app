import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/app_asset.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/border_text_field.dart';
import '../../../../app/widgets/gap.dart';
import '../../../../app/widgets/loading_indicator.dart';
import '../../../../app/widgets/pushable_button.dart';
import '../../../../app/widgets/text.dart';
import '../blocs/sign_up/sign_up_bloc.dart';
import '../widgets/auth_card_container.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    super.dispose();
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
                  child: BlocConsumer<SignUpBloc, SignUpState>(
                    listener: (context, state) {
                      if (state is SignUpErrorState) {
                        Navigators().showMessage(
                          'Error: ${state.message}',
                          type: MessageType.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextCustom(
                            LocaleKeys.auth_create_an_account.tr(),
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
                          const Gap(height: 20),
                          BorderTextField(
                            controller: _repasswordController,
                            icon: AppAssets.passwordIcon,
                            inputType: TextInputType.visiblePassword,
                            isPasswordField: true,
                            hintText: LocaleKeys.auth_confirm_password.tr(),
                          ),
                          const Gap(height: 20),
                          PushableButton(
                            onPressed: () {
                              if (state is! SignUpLoadingState) {
                                context
                                    .read<SignUpBloc>()
                                    .add(RequestSignUpEvent(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      rePassword:
                                          _repasswordController.text.trim(),
                                    ));
                              }
                            },
                            type: state is SignUpLoadingState
                                ? PushableButtonType.disable
                                : PushableButtonType.primary,
                            child: state is SignUpLoadingState
                                ? const LoadingIndicatorWidget()
                                : TextCustom(
                                    LocaleKeys.auth_sign_up.tr(),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
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
