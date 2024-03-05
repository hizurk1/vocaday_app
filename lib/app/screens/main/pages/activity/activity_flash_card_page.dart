import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_logger.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/color.dart';
import '../../../../../features/cart/presentation/widgets/cart_icon_widget.dart';
import '../../../../../features/word/domain/entities/word_entity.dart';
import '../../../../../features/word/presentation/pages/word_detail_bottom_sheet.dart';
import '../../../../constants/gen/assets.gen.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/error_page.dart';
import '../../../../widgets/gap.dart';
import '../../../../widgets/pushable_button.dart';
import '../../../../widgets/status_bar.dart';
import '../../../../widgets/text.dart';
import 'widgets/activity_word_card_widget.dart';

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({
    super.key,
    required this.title,
    required this.words,
  });

  final String title;
  final List<WordEntity> words;

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  final _swipeController = CardSwiperController();
  final _flipController = FlipCardController();
  final wordCardsNotifier = ValueNotifier<List<WordCardWidget>>([]);
  final countIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    wordCardsNotifier.value = widget.words
        .map((entity) => WordCardWidget(
              entity: entity,
              controller: _flipController,
              onTap: () => _flipController.flipCard(),
              onLongPress: () => context.showBottomSheet(
                child: WordDetailBottomSheet(wordEntity: entity),
              ),
            ))
        .toList();
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    _flipController.resetCard(); //? Turn the card to the front
    if (direction == CardSwiperDirection.bottom) {
      return false;
    }
    if (wordCardsNotifier.value.isNotEmpty && currentIndex != null) {
      if (direction == CardSwiperDirection.top) {
        //! To avoid out of range
        final fixedIndex = previousIndex % wordCardsNotifier.value.length;
        logger.i(wordCardsNotifier.value[fixedIndex].entity.word);
        wordCardsNotifier.value.removeAt(fixedIndex);
        wordCardsNotifier.value = List.from(wordCardsNotifier.value);
        return false;
      } else {
        countIndex.value =
            (countIndex.value % wordCardsNotifier.value.length) + 1;
      }
      return true;
    }
    return false;
  }

  Future<void> _onKnewPressed() async {
    _swipeController.swipe(CardSwiperDirection.bottom);
    final fixedIndex = countIndex.value % wordCardsNotifier.value.length;
    logger.i(wordCardsNotifier.value[fixedIndex].entity.word);
    wordCardsNotifier.value.removeAt(fixedIndex);
    wordCardsNotifier.value = List.from(wordCardsNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor:
            context.backgroundColor.darken(context.isDarkTheme ? 0 : .05),
        appBar: AppBarCustom(
          leading: const BackButton(),
          action: const CartIconWidget(),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextCustom(
                LocaleKeys.activity_category.tr(
                  args: [widget.title],
                ),
                style: context.textStyle.bodyM.bold.bw,
              ),
              const Gap(height: 3),
              ValueListenableBuilder(
                valueListenable: wordCardsNotifier,
                builder: (context, list, _) {
                  if (list.isEmpty) {
                    return TextCustom(
                      "${list.length}/${list.length}",
                      style: context.textStyle.labelL.grey,
                    );
                  }
                  return ValueListenableBuilder(
                    valueListenable: countIndex,
                    builder: (context, index, _) {
                      return TextCustom(
                        "${(index % list.length) + 1}/${list.length}",
                        style: context.textStyle.labelL.grey,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: wordCardsNotifier,
            builder: (context, wordCards, _) {
              if (wordCards.isEmpty) {
                return ErrorPage(
                  text: LocaleKeys.activity_no_more_words_left.tr(),
                  image: Assets.jsons.notFoundDog,
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: CardSwiper(
                      controller: _swipeController,
                      cardsCount: wordCards.length,
                      numberOfCardsDisplayed: wordCards.length > 1 ? 2 : 1,
                      onSwipe: _onSwipe,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 35.h,
                      ).copyWith(bottom: 20.h),
                      cardBuilder: (
                        context,
                        index,
                        horizontalOffsetPercentage,
                        verticalOffsetPercentage,
                      ) {
                        //! To avoid out of range
                        final fixedIndex = index % wordCards.length;
                        return wordCards[fixedIndex];
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                    child: PushableButton(
                      onPressed: _onKnewPressed,
                      text: LocaleKeys.activity_i_knew.tr(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
