import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';

import '../../../../app/constants/app_asset.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/utils/util_functions.dart';
import '../../../../app/widgets/bottom_sheet_custom.dart';
import '../../../../app/widgets/divider.dart';
import '../../../../app/widgets/expansion_tile_custom.dart';
import '../../../../app/widgets/gap.dart';
import '../../../../app/widgets/highlight_text.dart';
import '../../../../app/widgets/text.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../core/extensions/string.dart';
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
      initialChildSize: 0.6,
      minChildSize: 0.15,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      children: [
        _buildBigWord(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextCustom(
              "($getTypes)",
              style: context.textStyle.bodyS.grey,
            ),
            Container(
              margin: EdgeInsets.only(right: 5.w),
              child: LikeButton(
                size: 28.h,
                likeBuilder: (isLiked) {
                  final color = isLiked ? AppColor().red : AppColor().grey400;
                  return SvgPicture.asset(
                    isLiked ? AppAssets.loved : AppAssets.love,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  );
                },
              ),
            ),
          ],
        ),
        ...wordEntity.meanings.mapIndexed(
          (index, meaning) => _buildMeaningBlock(
            index: index,
            meaning: meaning,
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildMeaningBlock({
    required int index,
    required MeaningEntity meaning,
    required BuildContext context,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DividerCustom(
          margin: EdgeInsets.only(top: 10.h, bottom: 12.h),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? Index
            Container(
              height: 25.h,
              width: 25.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: context.theme.primaryColorDark,
              ),
              child: Center(
                child: TextCustom(
                  "${index + 1}",
                  textAlign: TextAlign.center,
                  style: context.textStyle.labelL.bold.white,
                ),
              ),
            ),
            const Gap(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '(${meaning.type.toLowerCase()})',
                          style: context.textStyle.bodyL.bold.primaryDark,
                        ),
                        const WidgetSpan(child: Gap(width: 5)),
                        TextSpan(
                          text: "${meaning.meaning}.",
                          style: context.textStyle.bodyL.bold.bw.copyWith(
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(height: 5.h),
                  ExpansionTileCustom(
                    count: meaning.examples.length,
                    title: LocaleKeys.word_detail_examples
                        .plural(meaning.examples.length),
                    titleStyle: context.textStyle.bodyM.bold.primaryDark,
                    isExpandFirst: index == 0,
                    itemPadding: EdgeInsets.symmetric(vertical: 8.h),
                    children: meaning.examples
                        .mapIndexed(
                          (i, e) => HighlightText(
                            text: "${i + 1}. ${e.capitalizeFirstLetter}.",
                            highlight: wordEntity.word.toLowerCase(),
                            style: context.textStyle.bodyM.bw,
                          ),
                        )
                        .toList(),
                  ),
                  if (meaning.synonyms.isNotEmpty)
                    ExpansionTileCustom(
                      count: meaning.synonyms.length,
                      title: LocaleKeys.word_detail_synonyms
                          .plural(meaning.synonyms.length),
                      titleStyle: context.textStyle.bodyM.bold.primaryDark,
                      isExpandFirst: index == 0,
                      bodyPadding: EdgeInsets.only(
                          bottom: 10.h, right: 10.w, left: 25.w, top: 8.h),
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: meaning.synonyms
                            .map(
                              (text) => Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3.h,
                                  horizontal: 8.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: context.theme.primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: TextCustom(
                                  text.toLowerCase(),
                                  style: context.textStyle.bodyS.bold.primary,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBigWord(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
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
                padding: EdgeInsets.symmetric(horizontal: 8.w),
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
