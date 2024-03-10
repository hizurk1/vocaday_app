import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../config/app_logger.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/string.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../../../word/presentation/blocs/word_list/word_list_cubit.dart';
import '../cubits/cart/cart_cubit.dart';

class WordBag {
  final String name;
  final List<WordEntity> words;
  bool isSelected;
  WordBag({required this.name, required this.words, this.isSelected = false});
}

class GameSelectWordBagPage extends StatefulWidget {
  const GameSelectWordBagPage({super.key, required this.route});

  final String route;

  @override
  State<GameSelectWordBagPage> createState() => _GameSelectWordBagPageState();
}

class _GameSelectWordBagPageState extends State<GameSelectWordBagPage> {
  @override
  Widget build(BuildContext context) {
    return DynamicBottomSheetCustom(
      showDragHandle: true,
      child: BlocSelector<WordListCubit, WordListState, List<WordEntity>>(
        selector: (state) => state is WordListLoadedState ? state.wordList : [],
        builder: (context, wordList) {
          if (wordList.isEmpty) {
            return SizedBox(
              height: context.screenHeight / 4,
              child: const LoadingIndicatorPage(),
            );
          }
          return BlocSelector<CartCubit, CartState, List<WordBag>>(
            selector: (state) {
              if (state is CartLoadedState) {
                List<WordBag> wordBags = [];
                for (final bag in state.entity.bags) {
                  wordBags.add(WordBag(
                    name: bag.label,
                    words: wordList
                        .where((e) => bag.words.contains(e.word))
                        .toList(),
                  ));
                }
                return wordBags;
              } else {
                return [];
              }
            },
            builder: (context, List<WordBag> wordBags) {
              if (wordBags.isEmpty) {
                return ErrorPage(
                  text: LocaleKeys.activity_no_word_bag_found.tr(
                    args: [
                      LocaleKeys.activity_word
                          .plural(AppValueConst.minWordInBagToPlay)
                    ],
                  ).fixBreakLine,
                  image: Assets.jsons.notFoundDog,
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h)
                    .copyWith(top: 5.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextCustom(
                      LocaleKeys.activity_select_word_bag_play_game.tr(),
                      style: context.textStyle.titleS.bold.bw,
                    ),
                    const Gap(height: 5),
                    TextCustom(
                      LocaleKeys.activity_select_word_bag_play_game_note.tr(
                        args: [
                          LocaleKeys.activity_word
                              .plural(AppValueConst.minWordInBagToPlay)
                        ],
                      ),
                      style: context.textStyle.bodyS.grey,
                    ),
                    const Gap(height: 10),
                    _WordBagCheckBoxListTile(wordBags: wordBags),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _WordBagCheckBoxListTile extends StatefulWidget {
  const _WordBagCheckBoxListTile({required this.wordBags});

  final List<WordBag> wordBags;

  @override
  State<_WordBagCheckBoxListTile> createState() =>
      _WordBagCheckBoxListTileState();
}

class _WordBagCheckBoxListTileState extends State<_WordBagCheckBoxListTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: context.screenHeight / 4,
            maxHeight: context.screenHeight / 2,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.wordBags
                  .map(
                    (e) => Material(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        value: e.isSelected,
                        enabled: e.words.length >= 5,
                        activeColor: context.theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        selectedTileColor: context.theme.primaryColorLight,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r)),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => e.isSelected = value);
                        },
                        title: TextCustom(
                          e.name,
                          style: e.words.length >= 5
                              ? context.textStyle.bodyM.bw
                              : context.textStyle.bodyM.grey80,
                        ),
                        subtitle: TextCustom(
                          LocaleKeys.activity_word.plural(e.words.length),
                          style: context.textStyle.caption.grey80,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const Gap(height: 10),
        PushableButton(
          onPressed: () {
            final list = widget.wordBags
                .where((e) => e.isSelected)
                .expand((e) => e.words)
                .toList();
            logger.i(list.map((e) => e.word).toList());
          },
          text: LocaleKeys.activity_play.tr(),
        ),
      ],
    );
  }
}
