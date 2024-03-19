import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_logger.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/color.dart';
import '../../../../../features/user/user_cart/presentation/cubits/cart_bag/cart_bag_cubit.dart';
import '../../../../../features/user/user_cart/presentation/widgets/cart_icon_widget.dart';
import '../../../../../features/user/user_profile/presentation/cubits/known/known_word_cubit.dart';
import '../../../../../features/user/user_profile/presentation/widgets/known_word/known_word_button_widget.dart';
import '../../../../../features/word/domain/entities/word_entity.dart';
import '../../../../../features/word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../../../../features/word/presentation/pages/word_detail_bottom_sheet.dart';
import '../../../../../injection_container.dart';
import '../../../../constants/gen/assets.gen.dart';
import '../../../../managers/shared_preferences.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../utils/event_transformer.dart';
import '../../../../widgets/widgets.dart';
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
  final _debounce = Debouncer();

  @override
  void initState() {
    super.initState();
    wordCardsNotifier.value = _renderCards(widget.words);
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _debounce.dispose();
    super.dispose();
  }

  List<WordCardWidget> _renderCards(List<WordEntity> list) {
    return list
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
        await _addToCartBag(wordCardsNotifier.value[fixedIndex].entity.word);

        // wordCardsNotifier.value.removeAt(fixedIndex);
        // wordCardsNotifier.value = List.from(wordCardsNotifier.value);
        return false;
      } else {
        countIndex.value =
            (countIndex.value % wordCardsNotifier.value.length) + 1;
      }
      return true;
    }
    return false;
  }

  Future<void> _addToCartBag(String word) async {
    await context.read<CartBagCubit>().addToCartBag(word);
  }

  Future<void> _onKnewPressed(List<WordEntity> list) async {
    _swipeController.swipe(CardSwiperDirection.bottom);
    final fixedIndex = countIndex.value % wordCardsNotifier.value.length;

    await context
        .read<KnownWordCubit>()
        .addKnownWord(wordCardsNotifier.value[fixedIndex].entity.word, list);
    logger.i("Known words: ${sl<SharedPrefManager>().getKnownWords}");

    wordCardsNotifier.value.removeAt(fixedIndex);
    wordCardsNotifier.value = List.from(wordCardsNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: BlocSelector<CartBagCubit, CartBagState, List<WordEntity>?>(
        selector: (state) {
          if (state.status == CartBagStatus.loaded) {
            final bags = state.entity?.words ?? [];
            return widget.words.whereNot((e) => bags.contains(e.word)).toList();
          }
          return null;
        },
        builder: (context, exBags) {
          if (exBags != null) {
            wordCardsNotifier.value = _renderCards(exBags);
          }

          return Scaffold(
            backgroundColor:
                context.backgroundColor.darken(context.isDarkTheme ? 0 : .05),
            appBar: AppBarCustom(
              leading: BackButton(
                style: ButtonStyle(iconSize: MaterialStateProperty.all(24.r)),
              ),
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
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  child: BlocSelector<WordListCubit, WordListState,
                      List<WordEntity>>(
                    selector: (state) =>
                        state is WordListLoadedState ? state.wordList : [],
                    builder: (context, list) {
                      return KnownWordButtonWidget(
                        onPressed: () => _onKnewPressed(list),
                      );
                    },
                  ),
                ),
                builder: (context, wordCards, child) {
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
                      child!,
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
