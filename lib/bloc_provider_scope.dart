import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/managers/connection.dart';
import 'app/managers/language.dart';
import 'app/managers/theme.dart';
import 'features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'features/user/presentation/blocs/user_data/user_data_bloc.dart';
import 'features/word/presentation/blocs/word_list/word_list_bloc.dart';
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
        BlocProvider(create: (_) => sl<LanguageBloc>()),
        //* Internet connection controller
        BlocProvider(create: (_) => sl<ConnectionBloc>()),
        //* Word List Bloc
        BlocProvider(create: (_) => sl<WordListBloc>()),
        //* Authentication Bloc
        BlocProvider(create: (_) => sl<AuthBloc>()),
        //* User Cubit
        BlocProvider(create: (_) => sl<UserDataBloc>()),
      ],
      child: child,
    );
  }
}
