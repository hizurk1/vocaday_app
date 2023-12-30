import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/constants/app_string.dart';
import 'app/managers/connection.dart';
import 'app/managers/navigation.dart';
import 'app/managers/theme.dart';
import 'app/routes/route_manager.dart';
import 'app/themes/app_theme.dart';
import 'injection_container.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 827),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => BlocListener<ConnectionBloc, InternetState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, internet) {
          final isOffline = internet.status == ConnectionStatus.offline;
          Navigators().showMessage(
            isOffline
                ? AppStringConst.internetFailureMessage
                : "You're back to the internet",
            type: isOffline ? MessageType.error : MessageType.success,
          );
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) => previous != current,
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
