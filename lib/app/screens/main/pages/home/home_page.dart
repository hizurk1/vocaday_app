import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/string.dart';
import '../../../../../features/user/user_profile/presentation/cubits/leader_board/leader_board_cubit.dart';
import '../../../../../features/user/user_profile/presentation/pages/main_home/home_check_in_bottom_sheet.dart';
import '../../../../../features/user/user_profile/presentation/pages/main_home/home_leaderboard_page.dart';
import '../../../../../features/user/user_profile/presentation/widgets/main_home/home_check_in_panel.dart';
import '../../../../../features/user/user_profile/presentation/widgets/main_home/home_top_app_bar.dart';
import '../../../../../features/word/presentation/widgets/main_home/main_new_word_panel.dart';
import '../../../../../injection_container.dart';
import '../../../../constants/app_const.dart';
import '../../../../managers/navigation.dart';
import '../../../../managers/shared_preferences.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/custom_coach_message.dart';
import '../../../../widgets/widgets.dart';

part 'widgets/home_text_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onShowCoach});

  final void Function()? onShowCoach;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late TutorialCoachMark tutorialCoachMark;
  final List<TargetFocus> targets = [];
  final GlobalKey _bagKey = GlobalKey();
  final GlobalKey _attendaceKey = GlobalKey();
  final GlobalKey _dailyWordKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (sl<SharedPrefManager>().getCoachMarkHome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 2), () => _onShowCoachMark());
      });
    }
  }

  _onCompleteTutorialCoachMark() async {
    await sl<SharedPrefManager>().saveCoachMarkHome();
  }

  void _onShowCoachMark() {
    tutorialCoachMark = TutorialCoachMark(
      pulseEnable: false,
      textSkip: LocaleKeys.common_skip.tr(),
      unFocusAnimationDuration: const Duration(milliseconds: 400),
      opacityShadow: 0.9,
      onFinish: () {
        _onCompleteTutorialCoachMark();
        widget.onShowCoach?.call();
      },
      onSkip: () {
        _onCompleteTutorialCoachMark();
        widget.onShowCoach?.call();
        return true;
      },
      targets: targets
        ..addAll([
          TargetFocus(
            identify: _bagKey.toString(),
            keyTarget: _bagKey,
            paddingFocus: 0,
            contents: [
              TargetContent(
                padding: EdgeInsets.zero,
                builder: (context, controller) {
                  return CustomCoachMessageWidget(
                    title: LocaleKeys.tutorial_word_bag_title.tr(),
                    subTitle:
                        LocaleKeys.tutorial_word_bag_subtitle.tr().fixBreakLine,
                    onNext: () => controller.next(),
                  );
                },
              )
            ],
          ),
          TargetFocus(
            identify: _attendaceKey.toString(),
            keyTarget: _attendaceKey,
            shape: ShapeLightFocus.RRect,
            radius: 20.r,
            paddingFocus: 0,
            contents: [
              TargetContent(
                padding: EdgeInsets.zero,
                builder: (context, controller) {
                  return CustomCoachMessageWidget(
                    title: LocaleKeys.tutorial_check_in_title.tr(),
                    subTitle: LocaleKeys.tutorial_check_in_subtitle.tr(
                      args: [
                        LocaleKeys.user_data_point
                            .plural(AppValueConst.attendancePoint),
                        LocaleKeys.user_data_gold
                            .plural(AppValueConst.attendanceGold),
                      ],
                    ),
                    onNext: () => controller.next(),
                    onPrevious: () => controller.previous(),
                  );
                },
              )
            ],
          ),
          TargetFocus(
            identify: _dailyWordKey.toString(),
            keyTarget: _dailyWordKey,
            shape: ShapeLightFocus.RRect,
            radius: 20.r,
            paddingFocus: 0,
            contents: [
              TargetContent(
                padding: EdgeInsets.zero,
                align: ContentAlign.top,
                builder: (context, controller) {
                  return CustomCoachMessageWidget(
                    title: LocaleKeys.tutorial_daily_word_title.tr(),
                    subTitle: LocaleKeys.tutorial_daily_word_subtitle.tr(),
                    onNext: () => controller.next(),
                    onPrevious: () => controller.previous(),
                  );
                },
              )
            ],
          ),
        ]),
    )..show(context: context);
  }

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
          appBar: AppBarCustom(
            child: HomeTopAppBar(bagKey: _bagKey),
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
                const Gap(height: 20),
                GestureDetector(
                  key: _attendaceKey,
                  onTap: _onOpenCalendar,
                  child: const CheckInPanel(),
                ),
                const Gap(height: 20),
                _HomeTextTitle(LocaleKeys.home_every_day_new_word.tr()),
                const Gap(height: 20),
                MainNewWordPanelWidget(key: _dailyWordKey),
                const Gap(height: 20),
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
                HomeLeaderboardPage(type: LeaderboardType.point),
                HomeLeaderboardPage(type: LeaderboardType.attendance),
              ],
            ),
          ),
        );
      }),
    );
  }
}
