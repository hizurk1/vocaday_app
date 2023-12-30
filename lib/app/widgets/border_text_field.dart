import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/build_context.dart';

class BorderTextField extends StatefulWidget {
  const BorderTextField({
    super.key,
    required TextEditingController controller,
    required this.hintText,
    required this.icon,
    this.hintColor,
    this.enable = true,
    this.borderColor,
    this.maxLength = 50,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.isPasswordField = false,
    this.textCapitalization = TextCapitalization.none,
    this.hasLeading = true,
  }) : _controller = controller;

  final TextEditingController _controller;
  final Color? borderColor;
  final String icon;
  final String hintText;
  final Color? hintColor;
  final TextInputType inputType;
  final bool isPasswordField;
  final TextCapitalization textCapitalization;
  final int maxLength;
  final int maxLines;
  final bool enable;
  final bool hasLeading;

  @override
  State<BorderTextField> createState() => _BorderTextFieldState();
}

class _BorderTextFieldState extends State<BorderTextField> {
  bool eyeState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: widget.maxLines > 1 ? 10.w : 0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? context.theme.hintColor.withOpacity(.2),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: widget._controller,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        enabled: widget.enable,
        textCapitalization: widget.textCapitalization,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 2.h),
          icon: widget.hasLeading
              ? SvgPicture.asset(
                  widget.icon,
                  height: 25,
                  width: 25,
                )
              : null,
          hintText: widget.hintText,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: widget.hintColor ?? context.theme.hintColor.withOpacity(.5),
          ),
          counterText: '',
          suffixIcon: widget.isPasswordField
              ? GestureDetector(
                  onTap: () => setState(() {
                    eyeState = !eyeState;
                  }),
                  child: Opacity(
                    opacity: .5,
                    child: SvgPicture.asset(
                      'assets/icons/eye_${eyeState ? 'open' : 'close'}.svg',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                )
              : null,
        ),
        obscureText: widget.isPasswordField ? !eyeState : false,
        keyboardType: widget.inputType,
        cursorWidth: 2,
        cursorColor: context.textTheme.bodyMedium?.color,
        textAlignVertical: widget.isPasswordField
            ? TextAlignVertical.center
            : TextAlignVertical.top,
      ),
    );
  }
}
