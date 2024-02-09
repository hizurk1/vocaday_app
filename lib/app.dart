import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/managers/connection.dart';
import 'app/managers/navigation.dart';
import 'app/managers/theme.dart';
import 'app/routes/route_manager.dart';
import 'app/themes/app_theme.dart';
import 'injection_container.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void checkInternet(InternetState internet, BuildContext context) {
    if (internet.status == ConnectionStatus.offline) {
      Navigators().showMessage("Internet was lost!", type: MessageType.error);
    }
    if (internet.status == ConnectionStatus.online) {
      Navigators().showMessage("Back to online", type: MessageType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 827),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, __) => BlocListener<ConnectionBloc, InternetState>(
        listenWhen: (previous, current) => previous.status != current.status,
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
