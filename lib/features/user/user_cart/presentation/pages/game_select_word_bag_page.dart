import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/managers/navigation.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/string.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../../../word/presentation/blocs/word_list/word_list_cubit.dart';
import '../cubits/cart/cart_cubit.dart';
import 'word_bag_bottom_sheet_page.dart';

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
  Future<void> _onOpenCartBottomSheet(BuildContext context) async {
    await context.showBottomSheet(
      child: WordBagBottomSheetPage(),
    );
  }

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
                  info: TextButton(
                    onPressed: () => _onOpenCartBottomSheet(context),
                    child: TextCustom(
                      LocaleKeys.activity_open_your_bag.tr(),
                      style: context.textStyle.bodyM.primary.bold,
                    ),
                  ),
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
                    _WordBagCheckBoxListTile(
                      route: widget.route,
                      wordBags: wordBags,
                    ),
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
  const _WordBagCheckBoxListTile({
    required this.route,
    required this.wordBags,
  });

  final String route;
  final List<WordBag> wordBags;

  @override
  State<_WordBagCheckBoxListTile> createState() =>
      _WordBagCheckBoxListTileState();
}

class _WordBagCheckBoxListTileState extends State<_WordBagCheckBoxListTile> {
  void _onPlayPressed() {
    final list = widget.wordBags
        .where((e) => e.isSelected)
        .expand((e) => e.words)
        .toList()
      ..shuffle();
    if (list.isEmpty) {
      Navigators().showMessage(
        LocaleKeys.activity_you_have_to_select_one_bag.tr(),
        type: MessageType.info,
        opacity: 1,
      );
    } else {
      Navigators().popDialog();
      context.push(widget.route, extra: list);
    }
  }

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
                      color: Colors.transparent,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        value: e.isSelected,
                        enabled:
                            e.words.length >= AppValueConst.minWordInBagToPlay,
                        activeColor: context.colors.blue,
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
                          style:
                              e.words.length >= AppValueConst.minWordInBagToPlay
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
          onPressed: _onPlayPressed,
          text: LocaleKeys.common_start.tr(),
        ),
      ],
    );
  }
}
