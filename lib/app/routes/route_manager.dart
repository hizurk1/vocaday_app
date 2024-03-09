import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_logger.dart';
import '../../features/authentication/presentation/pages/authentication_page.dart';
import '../../features/authentication/presentation/pages/change_password_page.dart';
import '../../features/user/user_profile/presentation/pages/favourite/favourite_page.dart';
import '../../injection_container.dart';
import '../managers/navigation.dart';
import '../managers/shared_preferences.dart';
import '../screens/cart/cart_page.dart';
import '../screens/entry/entry_page.dart';
import '../screens/main/main_page.dart';
import '../screens/main/pages/activity/activity_flash_card_page.dart';
import '../screens/main/pages/activity/activity_list_word_page.dart';
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
        builder: (context, state) {
          logger.f(state.fullPath);
          return const AuthenticationPage();
        },
        routes: const [],
      ),
      //? Route: '/setting'
      GoRoute(
        path: AppRoutes.setting,
        pageBuilder: (context, state) {
          logger.f(state.fullPath);

          return slideTransitionPage(
            context: context,
            state: state,
            child: const SettingPage(),
          );
        },
        routes: const [],
      ),
      //? Route: '/favourite'
      GoRoute(
        path: AppRoutes.favourite,
        pageBuilder: (context, state) {
          logger.f(state.fullPath);

          return slideTransitionPage(
            context: context,
            state: state,
            child: const FavouritePage(),
          );
        },
        routes: const [],
      ),
      //? Route: '/changePassword'
      GoRoute(
        path: AppRoutes.changePassword,
        pageBuilder: (context, state) {
          logger.f(state.fullPath);

          return slideTransitionPage(
            context: context,
            state: state,
            child: const ChangePasswordPage(),
          );
        },
        routes: const [],
      ),
      //? Route: '/listWord'
      GoRoute(
        path: AppRoutes.listWord,
        pageBuilder: (context, state) {
          logger.f(state.fullPath);

          return slideTransitionPage(
            context: context,
            state: state,
            child: const ActivityListWordPage(),
          );
        },
        routes: const [],
      ),
      //? Route: '/flashCard'
      GoRoute(
        path: AppRoutes.flashCard,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          logger.f("${state.fullPath}");

          return slideTransitionPage(
            context: context,
            state: state,
            child: FlashCardPage(
              title: args?['title'] ?? '',
              words: args?['words'] ?? [],
            ),
          );
        },
        routes: const [],
      ),
      //? Route: '/cart'
      GoRoute(
        path: AppRoutes.cart,
        pageBuilder: (context, state) {
          logger.f("${state.fullPath}");

          return slideTransitionPage(
            context: context,
            state: state,
            child: const CartPage(),
          );
        },
        routes: const [],
      ),

      //? Route: '/main'
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) {
          return const MainPage();
        },
        routes: [
          //? Route: '/main/home'
          GoRoute(
            path: "home",
            builder: (context, state) {
              logger.f(state.fullPath);
              return const HomePage();
            },
            routes: const [],
          ),
          //? Route: '/main/search'
          GoRoute(
            path: "search",
            builder: (context, state) {
              logger.f(state.fullPath);
              return const SearchPage();
            },
            routes: const [],
          ),
          //? Route: '/main/activity'
          GoRoute(
            path: "activity",
            builder: (context, state) {
              logger.f(state.fullPath);
              return const ActivityPage();
            },
            routes: const [],
          ),
          //? Route: '/main/profile'
          GoRoute(
            path: "profile",
            builder: (context, state) {
              logger.f(state.fullPath);
              return const ProfilePage();
            },
            routes: const [],
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
