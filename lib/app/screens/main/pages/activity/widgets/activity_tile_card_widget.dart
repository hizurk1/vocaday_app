part of '../activity_page.dart';

class ActivityCard {
  final String icon;
  final String title;
  final String route;
  ActivityCard(this.icon, this.title, this.route);
}

class _ActivityTileCardWidget extends StatelessWidget {
  const _ActivityTileCardWidget({
    required this.title,
    required this.icon,
    required this.onPlayTap,
  });

  final String title;
  final String icon;
  final Function() onPlayTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: context.isDarkTheme
            ? context.colors.grey900
            : context.colors.grey100,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(.75),
            blurRadius: .5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      child: ListTileCustom(
        leading: SizedBox(
          height: 45.h,
          width: 45.w,
          child: SvgPicture.asset(
            icon,
            fit: BoxFit.contain,
          ),
        ),
        titlePadding: EdgeInsets.symmetric(horizontal: 15.w),
        title: TextCustom(
          title,
          style: context.textStyle.bodyM.bold.primaryDark,
        ),
        trailing: PushableButton(
          onPressed: onPlayTap,
          width: 75.w,
          height: 38.h,
          elevation: 3,
          borderRadius: 8,
          type: PushableButtonType.accent,
          text: LocaleKeys.activity_play.tr(),
          textStyle: context.textStyle.caption.white,
        ),
      ),
    );
  }
}
