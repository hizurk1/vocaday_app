import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../../features/user/user_cart/presentation/cubits/cart/cart_cubit.dart';
import '../../../../../features/user/user_cart/presentation/pages/game_select_word_bag_page.dart';
import '../../../../../features/user/user_profile/presentation/widgets/main_activity/activity_point_gold_widget.dart';
import '../../../../../features/word/presentation/widgets/main_activity/activity_learn_new_word_widget.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/app_element.dart';
import '../../../../constants/gen/assets.gen.dart';
import '../../../../routes/route_manager.dart';
import '../../../../themes/app_color.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/widgets.dart';

part "widgets/activity_tile_card_widget.dart";

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with AutomaticKeepAliveClientMixin {
  final activities = [
    ActivityCard(Assets.icons.quizIcon, AppStringConst.quiz, AppRoutes.quiz),
    ActivityCard(Assets.icons.block, AppStringConst.slidingPuzzle,
        AppRoutes.slidingPuzzle),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uid = context.read<AuthBloc>().state.user?.uid;
      if (uid != null) {
        await context.read<CartCubit>().getCart(uid);
      }
    });
  }

  _onPlayTap(String route) {
    context.showBottomSheet(child: GameSelectWordBagPage(route: route));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor:
          context.isDarkTheme ? context.colors.blue900 : context.colors.blue,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ActivityPointGoldWidget(),
            const Gap(height: 15),
            const ActivityLearnNewWordWidget(),
            const Gap(height: 15),
            _buildActivityCard(context),
            Gap(height: AppElement.navBarSafeSize.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context) {
    return Container(
      width: context.screenWidth,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.bottomSheetBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextCustom(
                LocaleKeys.activity_activity.tr(),
                style: context.textStyle.bodyL.bw.bold,
              ),
              const Gap(width: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withOpacity(.8),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: TextCustom(
                  activities.length.toString(),
                  style: context.textStyle.labelL.white.bold,
                ),
              ),
              // const Spacer(),
              // SvgPicture.asset(
              //   Assets.icons.questionMark,
              //   height: 25.h,
              //   width: 25.w,
              //   colorFilter: ColorFilter.mode(
              //     context.greyColor.withOpacity(.7),
              //     BlendMode.srcIn,
              //   ),
              // ),
            ],
          ),
          const Gap(height: 8),
          ...activities.mapIndexed(
            (index, e) => _ActivityTileCardWidget(
              title: e.title,
              icon: e.icon,
              onPlayTap: () => _onPlayTap(e.route),
            ),
          ),
        ],
      ),
    );
  }
}
