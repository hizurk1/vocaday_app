import 'package:flutter/material.dart';

import '../../../../../config/app_logger.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/user/presentation/widgets/main_home/home_top_app_bar.dart';
import '../../../../managers/navigation.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/sliver_tab_view.dart';
import '../../../../widgets/text.dart';
import 'widgets/check_in_panel.dart';

part 'widgets/home_text_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  _onOpenCalendar(bool showButton, bool showWeek) {
    logger.i("Open calendar! $showButton $showWeek");
  }

  Future<void> _onRefresh() async {
    Navigators().showLoading(
      task: Future.delayed(Durations.extralong2, () {
        Navigators().showMessage(
          LocaleKeys.profile_everything_is_up_to_date.tr(),
          type: MessageType.success,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: const AppBarCustom(
        child: HomeTopAppBar(),
      ),
      body: SliverTabView(
        onRefresh: _onRefresh,
        numberOfTabs: 2,
        padding: 20,
        // physics: const BouncingScrollPhysics(),
        topChild: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeTextTitle(LocaleKeys.home_general.tr()),
            CheckInPanel(
              onShowCalendar: _onOpenCalendar,
            ),
            // _HomeTextTitle(LocaleKeys.home_every_day_new_word.tr()),
            _HomeTextTitle(LocaleKeys.home_leaderboard.tr()),
          ],
        ),
        tabs: [
          Tab(text: LocaleKeys.home_tab_points.tr()),
          Tab(text: LocaleKeys.home_tab_attendances.tr()),
        ],
        tabBarView: TabBarView(
          physics: const ClampingScrollPhysics(),
          children: [
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
