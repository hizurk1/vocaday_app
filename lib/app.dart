import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/managers/connection.dart';
import 'app/managers/navigation.dart';
import 'app/managers/theme.dart';
import 'app/routes/route_manager.dart';
import 'app/themes/app_theme.dart';
import 'app/translations/translations.dart';
import 'injection_container.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void checkInternet(InternetState internet, BuildContext context) {
    if (internet.status == ConnectionStatus.offline) {
      Navigators().showMessage(
        LocaleKeys.utils_no_internet_connection.tr(),
        type: MessageType.error,
        actionText: LocaleKeys.common_retry.tr(),
        duration: 5,
        onAction: () {
          final state = context.read<ConnectionCubit>().state;
          if (state.status == ConnectionStatus.offline) {
            checkInternet(state, context);
          }
        },
      );
    }
    if (internet.status == ConnectionStatus.online) {
      Navigators().showMessage(
        LocaleKeys.utils_you_back_online.tr(),
        type: MessageType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 827),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, __) => BlocListener<ConnectionCubit, InternetState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, internet) => checkInternet(internet, context),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode,
          builder: (_, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: sl<AppRouter>().router,
              themeMode: state.themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            );
          },
        ),
      ),
    );
  }
}
