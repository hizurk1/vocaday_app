import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../themes/app_text_theme.dart';
import '../translations/translations.dart';
import 'gap.dart';
import 'text.dart';

class BottomSheetCustom extends StatelessWidget {
  const BottomSheetCustom({
    super.key,
    required this.textTitle,
    required this.body,
    required this.onAction,
    this.fullScreen = false,
    this.textAction,
  });

  final String textTitle;
  final Widget body;
  final bool fullScreen;
  final String? textAction;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final child = SingleChildScrollView(child: body);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleBar(context),
        fullScreen ? Expanded(child: child) : Flexible(child: child),
      ],
    );
  }

  Container _buildTitleBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
              color: context.shadowColor,
              offset: const Offset(0, 0.5),
              blurRadius: 1)
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //? Handler
            Container(
              height: 4.h,
              width: 40.w,
              margin: EdgeInsets.only(top: 12.h, bottom: 5.h),
              decoration: BoxDecoration(
                color: context.greyColor.withOpacity(.4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            //? Title
            Row(
              children: [
                const CloseButton(),
                const Gap(width: 5),
                Expanded(
                  child: Center(
                    child: TextCustom(
                      textTitle,
                      textAlign: TextAlign.center,
                      style: context.textStyle.bodyL.bw,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onAction,
                  child: TextCustom(
                    textAction ?? LocaleKeys.common_save.tr(),
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodyM.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
