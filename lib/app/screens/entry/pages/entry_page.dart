import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../features/authentication/presentation/pages/authentication_page.dart';
import '../../../../features/user/domain/usecases/get_user_data.dart';
import '../../../../features/user/presentation/blocs/user_data/user_data_bloc.dart';
import '../../../../features/word/presentation/blocs/search_word/search_word_bloc.dart';
import '../../../../injection_container.dart';
import '../../../managers/navigation.dart';
import '../../../translations/translations.dart';
import '../../main/main_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.user != current.user,
      listener: (_, state) {
        if (state is AuthenticatedState) {
          Navigators().showMessage(
            LocaleKeys.auth_sign_in_as_email.tr(
              namedArgs: {'email': state.user?.email ?? ''},
            ),
            type: MessageType.success,
          );
        }
      },
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (_, state) {
        if (state.user != null) {
          //* Authenticated
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => UserDataBloc(
                  sl<GetUserDataUsecase>(),
                  context.read<AuthBloc>().state.user?.uid ?? '',
                ),
              ),
              BlocProvider(create: (_) => sl<SearchWordBloc>()),
            ],
            child: const MainPage(),
          );
        }
        //* Unauthenticated
        else {
          return const AuthenticationPage();
        }
      },
    );
  }
}
