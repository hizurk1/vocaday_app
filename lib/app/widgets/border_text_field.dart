import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/build_context.dart';
import '../constants/app_asset.dart';
import '../themes/app_color.dart';
import '../themes/app_text_theme.dart';

class BorderTextField extends StatelessWidget {
  BorderTextField({
    super.key,
    this.controller,
    this.icon,
    this.hintColor,
    this.hintText = '',
    this.enable = true,
    this.borderColor,
    this.maxLength,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.isPasswordField = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
  });

  final TextEditingController? controller;
  final Color? borderColor;
  final String? icon;
  final String hintText;
  final Color? hintColor;
  final TextInputType inputType;
  final bool isPasswordField;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final int maxLines;

  /// If this value is set to `false`, the user can't type in this text field
  /// and an [InkWell] widget with [onTap] function will be available.
  final bool enable;
  final VoidCallback? onTap;

  final ValueNotifier<bool> eyeState = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: maxLines > 1 ? 10.w : 0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ??
              (context.isDarkTheme
                  ? context.colors.grey700
                  : context.colors.grey300),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength ?? 50,
        enabled: enable,
        textCapitalization: textCapitalization,
        style: context.textStyle.bodyS.bw,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 2.h),
          icon: SvgPicture.asset(
            icon ?? AppAssets.copyIcon,
            height: 25.h,
            width: 25.w,
            colorFilter:
                ColorFilter.mode(context.colors.grey400, BlendMode.srcIn),
          ),
          hintText: hintText,
          hintStyle: context.textStyle.bodyS.grey80,
          counterText: '',
          suffixIcon: isPasswordField
              ? GestureDetector(
                  onTap: () => eyeState.value = !eyeState.value,
                  child: Opacity(
                    opacity: .5,
                    child: ValueListenableBuilder(
                      valueListenable: eyeState,
                      builder: (context, value, _) {
                        return SvgPicture.asset(
                          'assets/icons/eye_${value ? 'open' : 'close'}.svg',
                          fit: BoxFit.scaleDown,
                        );
                      },
                    ),
                  ),
                )
              : null,
        ),
        obscureText: isPasswordField ? !eyeState.value : false,
        keyboardType: inputType,
        cursorWidth: 2,
        cursorColor: context.textTheme.bodyMedium?.color,
        textAlignVertical:
            isPasswordField ? TextAlignVertical.center : TextAlignVertical.top,
      ),
    );
    return enable
        ? child
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.r),
            child: child,
          );
  }
}
