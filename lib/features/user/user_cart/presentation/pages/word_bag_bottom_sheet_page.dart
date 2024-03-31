import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/managers/navigation.dart';
import '../../../../../app/routes/route_manager.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/string.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../../../word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../../../word/presentation/pages/word_detail_bottom_sheet.dart';
import '../../../user_profile/domain/entities/user_entity.dart';
import '../../../user_profile/presentation/cubits/user_data/user_data_cubit.dart';
import '../cubits/cart/cart_cubit.dart';
import '../cubits/cart_bag/cart_bag_cubit.dart';

class WordBagBottomSheetPage extends StatelessWidget {
  WordBagBottomSheetPage({super.key});

  final ValueNotifier<String> bagNameNotifier = ValueNotifier("");

  void _onTapWordCartItem(BuildContext context, WordEntity entity) {
    context.showBottomSheet(
      child: WordDetailBottomSheet(wordEntity: entity),
    );
  }

  Future<void> _onRemoveWordCartItem(
    BuildContext context,
    WordEntity entity,
  ) async {
    await context.read<CartBagCubit>().removeCartBagItem(entity.word);
  }

  void _onSearch(BuildContext context, String input) {
    if (context.read<CartBagCubit>().state.status != CartBagStatus.loading) {
      context.read<CartBagCubit>().searchCartBagItem(input);
    }
  }

  Future<void> _onSaveCartBag(BuildContext context, String uid) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.cart_name_your_word_bag.tr(),
      showIcon: false,
      body: BorderTextField(
        hintText: LocaleKeys.cart_my_word_bag_hint.tr(),
        autofocus: true,
        maxLength: 20,
        onChanged: (value) => bagNameNotifier.value = value,
      ),
      acceptText: LocaleKeys.common_save.tr(),
      onAccept: () async {
        final name = bagNameNotifier.value.trim();
        Navigators().popDialog();
        await Navigators().showLoading(
          tasks: [
            context.read<CartCubit>().addCartBag(
                uid, name.isEmpty ? LocaleKeys.cart_my_bag_default.tr() : name)
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
      selector: (state) => state is UserDataLoadedState ? state.entity : null,
      builder: (context, UserEntity? entity) {
        if (entity == null) return const LoadingIndicatorPage();
        return BlocSelector<WordListCubit, WordListState, List<WordEntity>>(
          selector: (state) =>
              state is WordListLoadedState ? state.wordList : [],
          builder: (context, wordList) {
            return BlocBuilder<CartBagCubit, CartBagState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                List<WordEntity> bagList = [];
                state.entity?.words.forEach((e) {
                  bagList.add(
                    wordList.firstWhere((entity) => entity.word == e),
                  );
                });
                return DraggableBottomSheetCustom(
                  initialChildSize: 1,
                  minChildSize: 0.2,
                  backgroundColor: context.backgroundColor,
                  textTitle: LocaleKeys.cart_user_bag.tr(args: [entity.name]),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  onAction: () {
                    if (bagList.isNotEmpty) {
                      _onSaveCartBag(context, entity.uid);
                    }
                  },
                  children: [
                    if (state.status == CartBagStatus.error) ...[
                      ErrorPage(text: state.message ?? ''),
                    ],
                    if (state.status == CartBagStatus.loaded) ...[
                      SearchWidget(
                        hintText: LocaleKeys.search_search_for_words.tr(),
                        onSearch: (value) => _onSearch(context, value),
                      ),
                      const Gap(height: 10),
                      ...bagList.isEmpty
                          ? [
                              ErrorPage(
                                text:
                                    LocaleKeys.cart_not_found_item_in_bag.tr(),
                                image: Assets.jsons.notFoundDog,
                                info: TextButton(
                                  onPressed: () =>
                                      context.push(AppRoutes.listWord),
                                  child: TextCustom(
                                    LocaleKeys.cart_go_to_store
                                        .tr()
                                        .fixBreakLine,
                                    style: context.textStyle.bodyM.primary.bold,
                                  ),
                                ),
                              )
                            ]
                          : bagList.reversed.map((entity) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: WordSmallCardWidget(
                                  onTap: () =>
                                      _onTapWordCartItem(context, entity),
                                  onRemove: () =>
                                      _onRemoveWordCartItem(context, entity),
                                  text: entity.word.toLowerCase(),
                                ),
                              )),
                    ],
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
