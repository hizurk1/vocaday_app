import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/utils/util_functions.dart';
import '../../../../app/widgets/widgets.dart';
import '../blocs/sign_up/sign_up_bloc.dart';
import '../widgets/auth_card_container.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with AutomaticKeepAliveClientMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    super.dispose();
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
                      child: BlocConsumer<SignUpBloc, SignUpState>(
                        listener: (context, state) {
                          if (state is SignUpErrorState) {
                            Navigators().showMessage(
                              '${LocaleKeys.common_error.tr()}: ${state.message}',
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
                              const Gap(height: 20),
                              BorderTextField(
                                controller: _repasswordController,
                                icon: Assets.icons.lock,
                                inputType: TextInputType.visiblePassword,
                                isPasswordField: true,
                                hintText: LocaleKeys.auth_confirm_password.tr(),
                              ),
                              const Gap(height: 20),
                              PushableButton(
                                onPressed: () {
                                  if (state is! SignUpLoadingState) {
                                    UtilFunction.unFocusTextField();
                                    context
                                        .read<SignUpBloc>()
                                        .add(RequestSignUpEvent(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
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
                                        style: context.textStyle.bodyS.white,
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
            ],
          ),
        ),
      ),
    );
  }
}
