part of '../home_page.dart';

class _CheckInPanel extends StatelessWidget {
  const _CheckInPanel({required this.onShowCalendar});

  final Function(bool showButton, bool showWeek) onShowCalendar;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 15.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.colors.blue,
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: context.colors.blue.lighten(.05),
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
                onTap: () => onShowCalendar.call(true, false),
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
                            AppAssets.attendance,
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
                              AppAssets.calendarOutline,
                              height: 20.h,
                              width: 20.w,
                            ),
                            const Gap(width: 10),
                            TextCustom(
                              "15/02/2024",
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
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: _buildAttendanceTile(
                    context: context,
                    onShowCalendar: () => onShowCalendar.call(false, true),
                    icon: AppAssets.week,
                    title: LocaleKeys.home_time.plural(0),
                    subTitle: LocaleKeys.home_this_week.tr(),
                  ),
                ),
                Expanded(
                  child: _buildAttendanceTile(
                    context: context,
                    onShowCalendar: () => onShowCalendar.call(false, false),
                    icon: AppAssets.lightning,
                    title: LocaleKeys.home_time.plural(0),
                    subTitle: LocaleKeys.home_this_month.tr(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAttendanceTile({
    required String icon,
    required String title,
    required String subTitle,
    required BuildContext context,
    required VoidCallback onShowCalendar,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onShowCalendar,
            borderRadius: BorderRadius.circular(45.r),
            child: Container(
              height: 45.h,
              width: 45.w,
              padding: EdgeInsets.all(9.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45.r / 2),
                color: context.theme.primaryColor.withOpacity(0.25),
                backgroundBlendMode: BlendMode.screen,
              ),
              child: SvgPicture.asset(
                icon,
                fit: BoxFit.scaleDown,
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
