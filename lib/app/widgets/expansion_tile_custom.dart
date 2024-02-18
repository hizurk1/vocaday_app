import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../../core/extensions/list.dart';
import 'text.dart';

// ignore: must_be_immutable
class ExpansionTileCustom extends StatelessWidget {
  ExpansionTileCustom({
    super.key,
    required this.title,
    this.count,
    this.child,
    this.children,
    this.titleStyle,
    this.isExpandFirst = false,
    this.arrowFromStart = true,
    this.iconSize = 16,
    this.iconColor,
    this.titlePadding,
    this.bodyPadding,
    this.itemPadding,
  });

  final String title;
  final TextStyle? titleStyle;
  final int? count;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? bodyPadding;
  final double iconSize;
  final Color? iconColor;
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? itemPadding;
  final bool isExpandFirst;
  final bool arrowFromStart;

  late ValueNotifier<bool> expandNotifier;

  @override
  Widget build(BuildContext context) {
    expandNotifier = ValueNotifier(isExpandFirst);

    return SizedBox(
      width: context.screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => expandNotifier.value = !expandNotifier.value,
            child: Container(
              width: context.screenWidth,
              padding: titlePadding ?? EdgeInsets.symmetric(vertical: 8.h),
              color: Colors.transparent,
              child: ValueListenableBuilder(
                  valueListenable: expandNotifier,
                  builder: (context, bool isExpand, _) {
                    return Row(
                      children: [
                        if (arrowFromStart)
                          Container(
                            margin: EdgeInsets.only(right: 8.w),
                            child: AnimatedContainer(
                              duration: Durations.medium1,
                              curve: Curves.easeOut,
                              transformAlignment: Alignment.center,
                              transform: isExpand
                                  ? Matrix4.rotationZ(pi / 2)
                                  : Matrix4.identity(),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: context.theme.primaryColorDark,
                                size: iconSize,
                              ),
                            ),
                          ),
                        TextCustom(
                          title +
                              (count != null && !isExpand ? " ($count)" : ''),
                          style: titleStyle,
                        ),
                        if (!arrowFromStart) ...[
                          const Spacer(),
                          Container(
                            margin: EdgeInsets.only(right: 8.w),
                            child: AnimatedContainer(
                              duration: Durations.medium1,
                              curve: Curves.easeOut,
                              transformAlignment: Alignment.center,
                              transform: isExpand
                                  ? Matrix4.rotationZ(pi / 2)
                                  : Matrix4.rotationZ(-pi / 2),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: context.theme.primaryColorDark,
                                size: iconSize,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: expandNotifier,
            builder: (context, bool isExpand, _) {
              return isExpand && (child != null || children != null)
                  ? Padding(
                      padding: bodyPadding ??
                          EdgeInsets.only(bottom: 5.h, right: 10.w, left: 25.w),
                      child: children.isNullOrEmpty
                          ? child
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children!
                                  .map<Widget>(
                                    (e) => Padding(
                                      padding: itemPadding ??
                                          EdgeInsets.symmetric(vertical: 3.h),
                                      child: e,
                                    ),
                                  )
                                  .toList(),
                            ),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
