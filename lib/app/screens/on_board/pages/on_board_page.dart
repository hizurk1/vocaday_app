import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../../injection_container.dart';
import '../../../managers/language.dart';
import '../../../managers/shared_preferences.dart';
import '../../../routes/route_manager.dart';
import '../../../translations/translations.dart';
import '../../../widgets/pushable_button.dart';
import 'select_language_page.dart';
import 'welcome_page.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  int currentPage = 0;
  final pages = [
    const SelectLanguagePage(),
    const WelcomePage(),
  ];

  Future<void> onButtonPress() async {
    if (currentPage == 0) {
      setState(() => currentPage = 1);
    } else {
      await sl<SharedPrefManager>().saveOnboardCheckedIn();
      if (mounted) {
        context.replace(AppRoutes.authentication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      buildWhen: (pre, cur) => pre.locale != cur.locale,
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            setState(() => currentPage = 0);
          },
          child: Scaffold(
            body: Stack(
              children: [
                pages[currentPage],
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 30.h,
                      ),
                      child: PushableButton(
                        onPressed: onButtonPress,
                        width: context.screenWidth,
                        text: currentPage == 0
                            ? LocaleKeys.common_next.tr()
                            : LocaleKeys.on_board_get_started.tr(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
