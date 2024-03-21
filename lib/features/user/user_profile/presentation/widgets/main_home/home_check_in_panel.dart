import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../../app/themes/app_color.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/gap.dart';
import '../../../../../../app/widgets/text.dart';
import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/extensions/color.dart';
import '../../../../../../core/extensions/date_time.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class CheckInPanel extends StatelessWidget {
  const CheckInPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 15.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCheckIn(context),
          BlocSelector<UserDataCubit, UserDataState, List<DateTime>>(
            selector: (state) => state is UserDataLoadedState
                ? state.entity.attendance ?? []
                : [],
            builder: (context, List<DateTime> listAtt) {
              final List<DateTime> inCurWeek =
                  listAtt.where((date) => date.isInCurrentWeek).toList();
              final List<DateTime> inCurMonth =
                  listAtt.where((date) => date.isInCurrentMonth).toList();

              return Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: _buildAttendanceTile(
                        context: context,
                        icon: Assets.icons.week,
                        title: LocaleKeys.home_time.plural(inCurWeek.length),
                        subTitle: LocaleKeys.home_this_week.tr(),
                      ),
                    ),
                    Expanded(
                      child: _buildAttendanceTile(
                        context: context,
                        icon: Assets.icons.lightning,
                        title: LocaleKeys.home_time.plural(inCurMonth.length),
                        subTitle: LocaleKeys.home_this_month.tr(),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildCheckIn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: context.theme.primaryColor
            .lighten(context.isDarkTheme ? 0.08 : 0.05),
        boxShadow: [
          BoxShadow(
            color: context.colors.blue600.withOpacity(.5),
            spreadRadius: .1,
            blurRadius: 3,
            offset: const Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 8.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(width: 5),
                    SvgPicture.asset(
                      Assets.icons.attendance,
                      height: 22.h,
                      width: 22.w,
                    ),
                    const Gap(width: 10),
                    TextCustom(
                      LocaleKeys.home_check_in.tr(),
                      style: context.textStyle.caption.white,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: context.colors.blue,
                    border: Border(
                      top: BorderSide(
                        width: 1.2,
                        color: context.colors.blue700.withOpacity(.35),
                      ),
                      left: BorderSide(
                        width: 1.2,
                        color: context.colors.blue700.withOpacity(.35),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.calendarOutline,
                        height: 20.h,
                        width: 20.w,
                      ),
                      const Gap(width: 10),
                      TextCustom(
                        DateTime.now().ddMMyyyy,
                        style: context.textStyle.labelL.white,
                      ),
                      const Gap(width: 5),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTile({
    required String icon,
    required String title,
    required String subTitle,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(45.r),
            child: ClipOval(
              child: Container(
                height: 45.dm,
                width: 45.dm,
                padding: EdgeInsets.all(9.dm),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor
                      .lighten(context.isDarkTheme ? 0.08 : 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.blue600.withOpacity(.5),
                      spreadRadius: .1,
                      blurRadius: 1.5,
                      offset: const Offset(0.5, 0.5),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  icon,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const Gap(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextCustom(
              title,
              style: context.textStyle.labelL.white.bold,
            ),
            const Gap(height: 3),
            TextCustom(
              subTitle,
              style: context.textStyle.labelM.copyWith(
                color: context.colors.white.withOpacity(.75),
              ),
            )
          ],
        )
      ],
    );
  }
}
