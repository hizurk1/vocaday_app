import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_manager.dart';
import '../../../../injection_container.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/sign_in/sign_in_bloc.dart';
import '../blocs/sign_up/sign_up_bloc.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/top_tab_bar.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SignInBloc>()),
        BlocProvider(create: (_) => sl<SignUpBloc>()),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Stack(
            children: [
              const AuthBackgroundWidget(),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: Column(
                    children: [
                      const TopTabBar(),
                      Expanded(
                        child: BlocListener<AuthBloc, AuthState>(
                          listenWhen: (previous, current) =>
                              previous != current,
                          listener: (context, state) {
                            context.replace(AppRoutes.init);
                          },
                          child: const TabBarView(
                            children: [
                              SignInPage(),
                              SignUpPage(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
