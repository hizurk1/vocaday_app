import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/managers/connection.dart';
import 'app/managers/language.dart';
import 'app/managers/theme.dart';
import 'app/screens/setting/cubits/schedule_notification/schedule_notification_cubit.dart';
import 'features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'features/user/user_cart/presentation/cubits/cart/cart_cubit.dart';
import 'features/user/user_cart/presentation/cubits/cart_bag/cart_bag_cubit.dart';
import 'features/user/user_profile/presentation/cubits/favourite/word_favourite_cubit.dart';
import 'features/user/user_profile/presentation/cubits/known/known_word_cubit.dart';
import 'features/user/user_profile/presentation/cubits/user_data/user_data_cubit.dart';
import 'features/word/presentation/blocs/word_list/word_list_cubit.dart';
import 'injection_container.dart';

class BlocProviderScope extends StatelessWidget {
  final Widget child;
  const BlocProviderScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //* Theme controller
        BlocProvider(
          create: (_) => sl<ThemeCubit>()..fetchTheme(),
          lazy: false,
        ),
        //* Language controller
        BlocProvider(create: (_) => sl<LanguageCubit>()),
        //* Internet connection controller
        BlocProvider(create: (_) => sl<ConnectionCubit>()..initialize()),
        //* Authentication Bloc
        BlocProvider(
          create: (_) => sl<AuthBloc>()..initAuthStream(),
        ),
        //* Word List Bloc
        BlocProvider(
          create: (_) => sl<WordListCubit>()..getAllWords(),
          lazy: false,
        ),
        //* User Cubit
        BlocProvider(create: (_) => sl<UserDataCubit>()),
        //* Schedule notification Cubit
        BlocProvider(create: (_) => ScheduleNotificationCubit()),
        //* Cart Cubit
        BlocProvider(create: (_) => sl<CartCubit>()),
        //* Cart Bag Cubit
        BlocProvider(create: (_) => sl<CartBagCubit>()),
        //* Favourite Cubit
        BlocProvider(
          create: (_) => sl<WordFavouriteCubit>()..getAllFavouriteWords(),
        ),
        //* Known word Cubit
        BlocProvider(
          create: (_) => sl<KnownWordCubit>()..getAllKnownWords(),
        ),
      ],
      child: child,
    );
  }
}
