import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/build_context.dart';
import '../constants/gen/assets.gen.dart';
import '../themes/app_color.dart';
import '../themes/app_text_theme.dart';
import 'gap.dart';
import 'text.dart';

class BorderDropdownField extends StatelessWidget {
  BorderDropdownField({
    super.key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.icon,
  });

  final String initialValue;
  final String? icon;
  final List<String> items;
  final Function(String? value) onChanged;

  final ValueNotifier<String> notifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    notifier.value = initialValue;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.isDarkTheme
              ? context.colors.grey700
              : context.colors.grey300,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon ?? Assets.icons.copy,
            height: 25.h,
            width: 25.w,
            colorFilter: ColorFilter.mode(
              context.colors.grey400,
              BlendMode.srcIn,
            ),
          ),
          const Gap(width: 16),
          Flexible(
            fit: FlexFit.tight,
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (context, notifierValue, _) {
                return DropdownButton(
                  value: notifierValue,
                  isExpanded: true,
                  style: context.textStyle.bodyS.bw,
                  underline: const SizedBox(),
                  elevation: 1,
                  borderRadius: BorderRadius.circular(5),
                  items: items
                      .mapIndexed(
                        (index, value) => DropdownMenuItem<String>(
                          value: value,
                          child: TextCustom(value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    onChanged(value);
                    notifier.value = value ?? initialValue;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
