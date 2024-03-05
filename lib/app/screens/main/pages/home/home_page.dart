import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/user/user_profile/data/models/user_model.dart';
import '../../../../../features/user/user_profile/presentation/cubits/leader_board/leader_board_cubit.dart';
import '../../../../../features/user/user_profile/presentation/pages/main_home/home_check_in_bottom_sheet.dart';
import '../../../../../features/user/user_profile/presentation/pages/main_home/home_leaderboard_page.dart';
import '../../../../../features/user/user_profile/presentation/widgets/main_home/home_check_in_panel.dart';
import '../../../../../features/user/user_profile/presentation/widgets/main_home/home_top_app_bar.dart';
import '../../../../../features/word/presentation/widgets/main_home/main_new_word_panel.dart';
import '../../../../../injection_container.dart';
import '../../../../managers/navigation.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/widgets.dart';

part 'widgets/home_text_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  _onOpenCalendar() {
    context.showBottomSheet(
      child: const HomeCheckInBottomSheet(),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    Navigators().showLoading(
      delay: Durations.extralong4,
      tasks: [
        context.read<LeaderBoardCubit>().getListUsers(),
      ],
      onFinish: Navigators().showMessage(
        LocaleKeys.profile_everything_is_up_to_date.tr(),
        type: MessageType.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => sl<LeaderBoardCubit>()..getListUsers(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: const AppBarCustom(
            child: HomeTopAppBar(),
          ),
          body: SliverTabView(
            onRefresh: () => _onRefresh(context),
            numberOfTabs: 2,
            padding: 20,
            // physics: const BouncingScrollPhysics(),
            topChild: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HomeTextTitle(LocaleKeys.home_general.tr()),
                GestureDetector(
                  onTap: _onOpenCalendar,
                  child: const CheckInPanel(),
                ),
                _HomeTextTitle(LocaleKeys.home_every_day_new_word.tr()),
                const MainNewWordPanelWidget(),
                _HomeTextTitle(LocaleKeys.home_leaderboard.tr()),
              ],
            ),
            tabs: [
              Tab(text: LocaleKeys.home_tab_points.tr()),
              Tab(text: LocaleKeys.home_tab_attendances.tr()),
            ],
            tabBarView: const TabBarView(
              physics: ClampingScrollPhysics(),
              children: [
                HomeLeaderboardPage(type: FilterUserType.point),
                HomeLeaderboardPage(type: FilterUserType.attendance),
              ],
            ),
          ),
        );
      }),
    );
  }
}
