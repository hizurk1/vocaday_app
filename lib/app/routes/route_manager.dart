import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/pages/authentication_page.dart';
import '../../features/user/presentation/pages/main_profile/profile_edit_personal_info_page.dart';
import '../../injection_container.dart';
import '../managers/navigation.dart';
import '../managers/shared_preferences.dart';
import '../screens/entry/entry_page.dart';
import '../screens/main/main_page.dart';
import '../screens/main/pages/activity/activity_page.dart';
import '../screens/main/pages/home/home_page.dart';
import '../screens/main/pages/profile/profile_page.dart';
import '../screens/main/pages/search/search_page.dart';
import '../screens/on_board/pages/on_board_page.dart';
import '../screens/setting/setting_page.dart';

part 'routes.dart';

class AppRouter {
  GoRouter router = GoRouter(
    navigatorKey: Navigators().navigationKey,
    initialLocation: AppRoutes.init,
    routes: [
      //? Route: '/'
      GoRoute(
        path: AppRoutes.init,
        builder: (context, state) {
          if (!sl<SharedPrefManager>().isCheckedInOnboard) {
            return const OnBoardPage();
          }
          return const EntryPage();
        },
      ),
      //? Route: '/authentication'
      GoRoute(
        path: AppRoutes.authentication,
        builder: (context, state) => const AuthenticationPage(),
        routes: const [],
      ),
      //? Route: '/setting'
      GoRoute(
        path: AppRoutes.setting,
        builder: (context, state) => const SettingPage(),
        routes: const [],
      ),
      //? Route: '/main'
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) => const MainPage(),
        routes: [
          //? Route: '/main/home'
          GoRoute(
            path: "home",
            builder: (context, state) => const HomePage(),
            routes: const [],
          ),
          //? Route: '/main/search'
          GoRoute(
            path: "search",
            builder: (context, state) => const SearchPage(),
            routes: const [],
          ),
          //? Route: '/main/activity'
          GoRoute(
            path: "activity",
            builder: (context, state) => const ActivityPage(),
            routes: const [],
          ),
          //? Route: '/main/profile'
          GoRoute(
            path: "profile",
            builder: (context, state) => const ProfilePage(),
            routes: [
              //? Route: '/main/profile/edit'
              GoRoute(
                path: "edit",
                pageBuilder: (context, state) => slideTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const ProfileEditPersonalInfoPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage slideTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, _, child) {
      return SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeIn)),
        ),
        child: child,
      );
    },
  );
}
