import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../features/authentication/presentation/pages/authentication_page.dart';
import '../../../features/user/presentation/cubits/user_data/user_data_cubit.dart';
import '../../../features/word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../widgets/status_bar.dart';
import '../main/main_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {},
        builder: (_, state) {
          if (state is AuthenticatedState) {
            context.read<UserDataCubit>().initDataStream(state.user?.uid);
            context.read<WordListCubit>().getAllWords();
            return const MainPage();
          } else {
            context.read<UserDataCubit>().cancelDataStream();
            return const AuthenticationPage();
          }
        },
      ),
    );
  }
}
