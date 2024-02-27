import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/extensions/build_context.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/utils/util_functions.dart';
import '../../../../../app/widgets/text.dart';
import '../../../domain/entities/word_entity.dart';
import '../../pages/word_detail_bottom_sheet.dart';

class SearchWordTileWidget extends StatelessWidget {
  const SearchWordTileWidget({
    super.key,
    required this.word,
  });

  final WordEntity word;

  void _onCopyToClipboard() {
    UtilFunction.copyToClipboard(word.word.toLowerCase());
  }

  void _onOpenWordDetail(BuildContext context) {
    context.showBottomSheet(
      child: WordDetailBottomSheet(wordEntity: word),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: context.backgroundColor,
      child: InkWell(
        onLongPress: _onCopyToClipboard,
        onTap: () => _onOpenWordDetail(context),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.theme.dividerColor.withOpacity(.2),
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: ListTile(
            tileColor: context.backgroundColor,
            title: TextCustom(
              word.word.toLowerCase(),
              style: context.textStyle.bodyM.bw,
            ),
            subtitle: TextCustom(
              word.meanings.first.type.toLowerCase(),
              style: context.textStyle.labelL.grey,
            ),
            trailing: GestureDetector(
              onTap: _onCopyToClipboard,
              child: SvgPicture.asset(
                Assets.icons.copy,
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
      ),
    );
  }
}
