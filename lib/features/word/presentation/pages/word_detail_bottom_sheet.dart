import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/constants/app_asset.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/utils/util_functions.dart';
import '../../../../app/widgets/bottom_sheet_custom.dart';
import '../../../../app/widgets/divider.dart';
import '../../../../app/widgets/text.dart';
import '../../domain/entities/word_entity.dart';

class WordDetailBottomSheet extends StatelessWidget {
  const WordDetailBottomSheet({super.key, required this.wordEntity});

  final WordEntity wordEntity;

  String get getTypes {
    return wordEntity.meanings
        .map((e) => e.type.toLowerCase())
        .toSet()
        .join(', ');
  }

  void _onCopyToClipboard() {
    UtilFunction.copyToClipboard(wordEntity.word.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetCustom(
      showDragHandleOnly: true,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      children: [
        _buildBigWord(context),
        Padding(
          padding: EdgeInsets.only(bottom: 10.h, top: 8.h),
          child: TextCustom(
            "($getTypes)",
            style: context.textStyle.bodyS.grey,
          ),
        ),
        const DividerCustom(),
      ],
    );
  }

  Widget _buildBigWord(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: wordEntity.word.toLowerCase(),
            style: context.textStyle.headingS.bold.bw.copyWith(
              letterSpacing: 1.5,
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: _onCopyToClipboard,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SvgPicture.asset(
                  AppAssets.copyIcon,
                  width: 25.w,
                  height: 25.h,
                  colorFilter: ColorFilter.mode(
                    context.colors.grey300,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
