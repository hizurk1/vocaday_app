import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/user/presentation/widgets/main_activity/activity_point_gold_widget.dart';
import '../../../../../features/word/presentation/widgets/main_activity/activity_learn_new_word_widget.dart';
import '../../../../constants/gen/assets.gen.dart';
import '../../../../themes/app_color.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/gap.dart';
import '../../../../widgets/list_tile_custom.dart';
import '../../../../widgets/pushable_button.dart';
import '../../../../widgets/text.dart';

part "widgets/activity_tile_card_widget.dart";

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final activities = [
    ActivityCard(Assets.icons.quizIcon, "Quiz"),
    ActivityCard(Assets.icons.saviourIcon, "Saviour"),
    ActivityCard(Assets.icons.arrangerIcon, "Word Jumble"),
  ];

  @override
  Widget build(BuildContext context) {
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
        color: context.theme.cardColor,
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
              const Spacer(),
              SvgPicture.asset(
                Assets.icons.questionMark,
                height: 25.h,
                width: 25.w,
                colorFilter: ColorFilter.mode(
                  context.greyColor.withOpacity(.7),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const Gap(height: 8),
          ...activities.mapIndexed(
            (index, e) => _ActivityTileCardWidget(
              title: e.title,
              icon: e.icon,
              onPlayTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
