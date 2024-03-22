// ignore_for_file: must_be_immutable

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/managers/shared_preferences.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/utils/util_functions.dart';
import '../../../../app/widgets/custom_coach_message.dart';
import '../../../../app/widgets/widgets.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../injection_container.dart';
import '../../../user/user_cart/presentation/widgets/add_to_bag_button_widget.dart';
import '../../../user/user_profile/presentation/widgets/favourite/favourite_button_widget.dart';
import '../../../user/user_profile/presentation/widgets/known_word/known_word_icon_widget.dart';
import '../../domain/entities/word_entity.dart';
import '../blocs/word_list/word_list_cubit.dart';

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

  _onTapChipItem(BuildContext context, String text) {
    final state = context.read<WordListCubit>().state;
    if (state is WordListLoadedState) {
      final result =
          state.wordList.firstWhereOrNull((e) => e.word == text.toUpperCase());
      if (result != null) {
        context.showBottomSheet(
            child: WordDetailBottomSheet(wordEntity: result));
      } else {
        Navigators().showMessage(
          LocaleKeys.utils_word_not_found_in_dictionary.tr(
            args: [text.toLowerCase()],
          ),
          type: MessageType.info,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheetCustom(
      showDragHandle: true,
      initialChildSize: 0.6,
      minChildSize: 0.15,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      children: [
        _buildBigWord(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextCustom(
                "($getTypes)",
                style: context.textStyle.bodyS.grey,
                maxLines: 2,
              ),
            ),
            _WordDetailActionsWidget(word: wordEntity.word),
          ],
        ),
        DashedLineCustom(
          margin: EdgeInsets.only(
            right: 5.w,
            top: 15.h,
            bottom: 8.h,
          ),
        ),
        if (wordEntity.synonyms.isNotEmpty)
          ExpansionTileCustom(
            count: wordEntity.synonyms.length,
            title: LocaleKeys.word_detail_synonyms
                .plural(wordEntity.synonyms.length),
            titleStyle: context.textStyle.titleS.bold.primaryDark,
            isExpandFirst: true,
            arrowFromStart: false,
            bodyPadding:
                EdgeInsets.only(bottom: 10.h, right: 10.w, left: 0, top: 8.h),
            child: _buildChips(wordEntity.synonyms, context),
          ),
        if (wordEntity.antonyms.isNotEmpty)
          ExpansionTileCustom(
            count: wordEntity.antonyms.length,
            title: LocaleKeys.word_detail_antonyms
                .plural(wordEntity.antonyms.length),
            titleStyle: context.textStyle.titleS.bold.primaryDark,
            isExpandFirst: true,
            arrowFromStart: false,
            bodyPadding:
                EdgeInsets.only(bottom: 10.h, right: 10.w, left: 0, top: 8.h),
            child: _buildChips(wordEntity.antonyms, context),
          ),
        ExpansionTileCustom(
          count: wordEntity.meanings.length,
          title: LocaleKeys.word_detail_definitions
              .plural(wordEntity.meanings.length),
          titleStyle: context.textStyle.titleS.bold.primaryDark,
          isExpandFirst: true,
          arrowFromStart: false,
          titlePadding: EdgeInsets.only(top: 8.h, bottom: 3.h),
          bodyPadding: EdgeInsets.only(bottom: 5.h, right: 10.w),
          children: wordEntity.meanings
              .mapIndexed(
                (index, meaning) => _buildMeaningBlock(
                  index: index,
                  meaning: meaning,
                  context: context,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildChips(List<String> items, BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items
          .map(
            (text) => GestureDetector(
              onTap: () => _onTapChipItem(context, text),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 3.h,
                  horizontal: 8.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: context.isDarkTheme
                        ? context.colors.blue400
                        : context.colors.blue,
                    width: 1.5,
                  ),
                ),
                child: TextCustom(
                  text.toLowerCase(),
                  style: context.textStyle.bodyS.bold.copyWith(
                    color: context.isDarkTheme
                        ? context.colors.blue400
                        : context.colors.blue,
                  ),
                ),
              ),
            ),
          )
          .toList(),
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
          margin: EdgeInsets.only(top: 10.h, bottom: 16.h),
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
                  if (meaning.examples.isNotEmpty)
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
                              text: "${i + 1}. $e.",
                              highlight: wordEntity.word.toLowerCase(),
                              highlightStyle: context.textStyle.bodyM.copyWith(
                                color: context.theme.colorScheme.error,
                              ),
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
                      child: _buildChips(meaning.synonyms, context),
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
        ],
      ),
    );
  }
}

class _WordDetailActionsWidget extends StatefulWidget {
  const _WordDetailActionsWidget({required this.word});

  final String word;

  @override
  State<_WordDetailActionsWidget> createState() =>
      _WordDetailActionsWidgetState();
}

class _WordDetailActionsWidgetState extends State<_WordDetailActionsWidget> {
  late TutorialCoachMark tutorialCoachMark;
  final List<TargetFocus> targets = [];
  final GlobalKey _favouriteKey = GlobalKey();
  final GlobalKey _knewKey = GlobalKey();
  final GlobalKey _addBagKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (sl<SharedPrefManager>().getCoachMarkWordDetail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _showTutorialCoachMark(),
        );
      });
    }
  }

  _onCompleteTutorialCoachMark() async {
    await sl<SharedPrefManager>().saveCoachMarkWordDetail();
  }

  _showTutorialCoachMark() {
    tutorialCoachMark = TutorialCoachMark(
      pulseEnable: false,
      textSkip: LocaleKeys.common_skip.tr(),
      unFocusAnimationDuration: const Duration(milliseconds: 400),
      opacityShadow: 0.9,
      onFinish: () {
        _onCompleteTutorialCoachMark();
      },
      onSkip: () {
        _onCompleteTutorialCoachMark();
        return true;
      },
      targets: targets
        ..addAll([
          TargetFocus(
            identify: _favouriteKey.toString(),
            keyTarget: _favouriteKey,
            paddingFocus: 0,
            contents: [
              TargetContent(
                padding: EdgeInsets.zero,
                builder: (context, controller) {
                  return CustomCoachMessageWidget(
                    title: LocaleKeys.tutorial_favourite_title.tr(),
                    onNext: () => controller.next(),
                  );
                },
              ),
            ],
          ),
          TargetFocus(
            identify: _knewKey.toString(),
            keyTarget: _knewKey,
            paddingFocus: 0,
            contents: [
              TargetContent(
                padding: EdgeInsets.zero,
                builder: (context, controller) {
                  return CustomCoachMessageWidget(
                    title: LocaleKeys.tutorial_mark_as_known.tr(),
                    onNext: () => controller.next(),
                    onPrevious: () => controller.previous(),
                  );
                },
              ),
            ],
          ),
          TargetFocus(
            identify: _addBagKey.toString(),
            keyTarget: _addBagKey,
            paddingFocus: 0,
            contents: [
              TargetContent(
                padding: EdgeInsets.zero,
                builder: (context, controller) {
                  return CustomCoachMessageWidget(
                    title: LocaleKeys.tutorial_add_to_bag.tr(),
                    onNext: () => controller.next(),
                    onPrevious: () => controller.previous(),
                  );
                },
              ),
            ],
          ),
        ]),
    )..show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FavouriteButtonWidget(key: _favouriteKey, word: widget.word),
        KnownWordIconWidget(knewKey: _knewKey, word: widget.word),
        AddToBagButtonWidget(bagKey: _addBagKey, word: widget.word),
      ],
    );
  }
}
