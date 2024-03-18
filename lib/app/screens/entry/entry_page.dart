import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../features/authentication/presentation/pages/authentication_page.dart';
import '../../../features/user/user_cart/presentation/cubits/cart/cart_cubit.dart';
import '../../../features/user/user_cart/presentation/cubits/cart_bag/cart_bag_cubit.dart';
import '../../../features/user/user_profile/presentation/cubits/favourite/word_favourite_cubit.dart';
import '../../../features/user/user_profile/presentation/cubits/known/known_word_cubit.dart';
import '../../../features/user/user_profile/presentation/cubits/user_data/user_data_cubit.dart';
import '../../../injection_container.dart';
import '../../managers/shared_preferences.dart';
import '../../widgets/status_bar.dart';
import '../main/main_page.dart';
import '../setting/cubits/schedule_notification/schedule_notification_cubit.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _rescheduleNotification();
    });
  }

  Future<void> _rescheduleNotification() async {
    final scheduleTime = sl<SharedPrefManager>().getScheduleNotiTime;
    if (scheduleTime != null) {
      await context
          .read<ScheduleNotificationCubit>()
          .setScheduleNotification(scheduleTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {},
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is AuthenticatedState) {
            return const AuthenticatedEntryPage(child: MainPage());
          } else {
            context.read<UserDataCubit>().cancelDataStream();
            return const AuthenticationPage();
          }
        },
      ),
    );
  }
}

class AuthenticatedEntryPage extends StatefulWidget {
  final Widget child;
  const AuthenticatedEntryPage({super.key, required this.child});

  @override
  State<AuthenticatedEntryPage> createState() => _AuthenticatedEntryPageState();
}

class _AuthenticatedEntryPageState extends State<AuthenticatedEntryPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final uid = context.read<AuthBloc>().state.user?.uid;
    if (uid != null) {
      context.read<UserDataCubit>().initDataStream(uid);
      context.read<CartBagCubit>().getCartBag();
      await Future.wait([
        context.read<WordFavouriteCubit>().syncFavourites(uid),
        context.read<KnownWordCubit>().syncKnowns(uid),
        context.read<CartCubit>().getCart(uid),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
