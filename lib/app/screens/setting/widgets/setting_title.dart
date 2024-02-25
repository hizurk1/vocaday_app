part of '../setting_page.dart';

class _SettingTitle extends StatelessWidget {
  const _SettingTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      color: context.greyColor.withOpacity(.15),
      child: TextCustom(
        title,
        style: context.textStyle.caption.grey,
      ),
    );
  }
}
