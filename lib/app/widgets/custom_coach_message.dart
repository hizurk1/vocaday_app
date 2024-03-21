import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/app_text_theme.dart';
import '../translations/translations.dart';
import 'gap.dart';
import 'text.dart';

class CustomCoachMessageWidget extends StatefulWidget {
  const CustomCoachMessageWidget({
    super.key,
    required this.onNext,
    this.onPrevious,
    this.title,
    this.subTitle,
  });

  final String? title;
  final String? subTitle;
  final void Function() onNext;
  final void Function()? onPrevious;

  @override
  State<CustomCoachMessageWidget> createState() =>
      _CustomCoachMessageWidgetState();
}

class _CustomCoachMessageWidgetState extends State<CustomCoachMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.title != null) ...[
            TextCustom(
              widget.title!,
              style: context.textStyle.titleS.white.bold,
              maxLines: 3,
            ),
          ],
          if (widget.subTitle != null) ...[
            const Gap(height: 5),
            TextCustom(
              widget.subTitle!,
              style: context.textStyle.bodyM.grey300,
              textAlign: TextAlign.justify,
              maxLines: 10,
            ),
          ],
          const Gap(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onPrevious != null)
                TextButton(
                  onPressed: widget.onPrevious,
                  child: TextCustom(
                    LocaleKeys.common_previous.tr(),
                    style: context.textStyle.bodyS.white,
                  ),
                ),
              TextButton(
                onPressed: widget.onNext,
                child: TextCustom(
                  LocaleKeys.common_next.tr(),
                  style: context.textStyle.bodyS.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
