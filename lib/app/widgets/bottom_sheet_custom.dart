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
    required this.children,
    this.textAction,
    this.onAction,
    this.initialChildSize = 0.6,
    this.minChildSize = 0.6,
    this.maxChildSize = 1,
  });

  final String textTitle;
  final List<Widget> children;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final String? textAction;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (_, controller) => Container(
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTitleBar(context),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: children,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //? Handler
            Container(
              height: 4.h,
              width: 34.w,
              margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
              decoration: BoxDecoration(
                color: context.greyColor,
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
