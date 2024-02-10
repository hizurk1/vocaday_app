import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/user/presentation/cubits/user_data/user_data_cubit.dart';
import '../../../../widgets/loading_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<UserDataCubit, UserDataState>(
          builder: (context, state) {
            if (state is UserDataLoadedState) {
              return Container();
            }
            return const LoadingIndicatorWidget();
          },
        ),
      ),
    );
  }
}
