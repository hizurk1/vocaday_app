import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/pages/authentication_page.dart';
import '../../injection_container.dart';
import '../managers/navigation.dart';
import '../managers/shared_preferences.dart';
import '../screens/entry/pages/entry_page.dart';
import '../screens/main/main_page.dart';
import '../screens/main/pages/activity/pages/activity_page.dart';
import '../screens/main/pages/home/pages/home_page.dart';
import '../screens/main/pages/profile/pages/profile_page.dart';
import '../screens/main/pages/search/pages/search_page.dart';
import '../screens/on_board/pages/on_board_page.dart';
import '../screens/setting/pages/setting_page.dart';

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
            routes: const [],
          ),
        ],
      ),
    ],
  );
}
