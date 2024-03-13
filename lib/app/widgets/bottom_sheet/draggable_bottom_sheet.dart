import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/string.dart';
import '../../themes/app_text_theme.dart';
import '../../translations/translations.dart';
import '../gap.dart';
import '../text.dart';
import '../unfocus.dart';

class DraggableBottomSheetCustom extends StatefulWidget {
  const DraggableBottomSheetCustom({
    super.key,
    required this.children,
    this.backgroundColor,
    this.padding,
    this.textTitle,
    this.textAction,
    this.onAction,
    this.showDragHandle = false,
    this.initialChildSize = 0.6,
    this.minChildSize = 0.5,
    this.maxChildSize = 1,
  });

  /// First loaded size of bottom sheet.
  final double initialChildSize;

  /// Min size of bottom sheet before it will be closed.
  final double minChildSize;

  /// Max size possible of bottom sheet.
  final double maxChildSize;

  /// Show drag handle. Best practice is only show if [textTitle] is `null`.
  final bool showDragHandle;

  /// Text in title of bottom sheet. If it sets to `null`, the bottom sheet
  /// title will be hidden.
  final String? textTitle;

  /// The body of bottom sheet. Excludes bottom sheet title.
  final List<Widget> children;

  /// Text for action button on the right.
  final String? textAction;

  /// Action button callback.
  final VoidCallback? onAction;

  /// Apply padding for bottom sheet title.
  final EdgeInsetsGeometry? padding;

  /// Color for background of bottom sheet, excludes title bar.
  final Color? backgroundColor;

  @override
  State<DraggableBottomSheetCustom> createState() =>
      _DraggableBottomSheetCustomState();
}

class _DraggableBottomSheetCustomState
    extends State<DraggableBottomSheetCustom> {
  final _dragController = DraggableScrollableController();
  final double _limitVelocity = 1000;

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  _onDragTitle(DragUpdateDetails details) {
    final ratio = details.delta.dy / context.screenHeight;
    final newChildSize = _dragController.size - ratio;

    if (newChildSize <= widget.maxChildSize) {
      _dragController.jumpTo(newChildSize);
    }
  }

  _onTapTitle() {
    _dragController.animateTo(
      widget.maxChildSize,
      duration: Durations.medium2,
      curve: Curves.easeOut,
    );
  }

  _onDragWithVelocity(DragEndDetails details) {
    if (details.primaryVelocity != null &&
        details.primaryVelocity!.abs() > _limitVelocity) {
      if (details.primaryVelocity! < 0) {
        _onTapTitle();
      } else if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: DraggableScrollableSheet(
          controller: _dragController,
          initialChildSize: widget.initialChildSize,
          minChildSize: widget.minChildSize,
          maxChildSize: widget.maxChildSize,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? context.bottomSheetBackground,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
            ),
            child: UnfocusArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: widget.padding,
                      children: widget.children,
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

  Widget _buildTitle() {
    return widget.textTitle.isNotNullOrEmpty
        ? GestureDetector(
            onTap: _onTapTitle,
            onVerticalDragUpdate: _onDragTitle,
            onVerticalDragEnd: _onDragWithVelocity,
            child: _buildTitleBar(context),
          )
        : widget.showDragHandle
            ? GestureDetector(
                onTap: _onTapTitle,
                onVerticalDragUpdate: _onDragTitle,
                onVerticalDragEnd: _onDragWithVelocity,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 5.h, right: 15.w, left: 15.w),
                  child: _buildDragHandle(context),
                ),
              )
            : const SizedBox();
  }

  Widget _buildDragHandle(BuildContext context) {
    return Container(
      height: 4.h,
      width: 34.w,
      margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
      decoration: BoxDecoration(
        color: context.greyColor,
        borderRadius: BorderRadius.circular(3),
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
            //* Handler
            _buildDragHandle(context),
            //* Title
            Row(
              children: [
                CloseButton(
                  style: ButtonStyle(iconSize: MaterialStateProperty.all(24.r)),
                ),
                const Gap(width: 5),
                Expanded(
                  child: Center(
                    child: TextCustom(
                      widget.textTitle ?? '',
                      textAlign: TextAlign.center,
                      style: context.textStyle.bodyL.bw,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onAction,
                  child: TextCustom(
                    widget.textAction ?? LocaleKeys.common_save.tr(),
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodyM.primaryDark,
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
