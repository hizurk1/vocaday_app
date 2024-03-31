import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/managers/navigation.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/date_time.dart';
import '../../../../authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../../../word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../../../word/presentation/pages/word_detail_bottom_sheet.dart';
import '../../../user_profile/presentation/cubits/known/known_word_cubit.dart';
import '../../domain/entities/cart_entity.dart';
import '../cubits/cart/cart_cubit.dart';
import '../cubits/cart_bag/cart_bag_cubit.dart';
import 'word_bag_bottom_sheet_page.dart';

enum CartBagMenu { rename, expand, remove, known }

class CartPageBody extends StatelessWidget {
  const CartPageBody({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    final uid = context.read<AuthBloc>().state.user?.uid;
    if (uid != null) {
      await context.read<CartCubit>().getCart(uid);
      Navigators().showMessage(LocaleKeys.profile_everything_is_up_to_date.tr(),
          type: MessageType.success);
    }
  }

  Future<void> _onOpenCartBottomSheet(BuildContext context) async {
    await context.showBottomSheet(
      child: WordBagBottomSheetPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WordListCubit, WordListState, List<WordEntity>>(
      selector: (state) => state is WordListLoadedState ? state.wordList : [],
      builder: (context, wordList) {
        return BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return const LoadingIndicatorPage();
            }
            if (state is CartErrorState) {
              return ErrorPage(text: state.message);
            }
            if (state is CartLoadedState) {
              final cartEntity = state.entity;
              return cartEntity.bags.isEmpty
                  ? ErrorPage(
                      text: LocaleKeys.search_not_found.tr(),
                      image: Assets.jsons.notFoundDog,
                      info: TextButton(
                        onPressed: () => _onOpenCartBottomSheet(context),
                        child: TextCustom(
                          LocaleKeys.activity_open_your_bag.tr(),
                          style: context.textStyle.bodyM.primary.bold,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _onRefresh(context),
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                              cartEntity.bags.mapIndexed((index, element) {
                            final wordItems = wordList
                                .where((e) => cartEntity.bags[index].words
                                    .contains(e.word))
                                .toList();
                            return _CartBagWidget(
                              index: index,
                              cartEntity: cartEntity,
                              wordItems: wordItems,
                            );
                          }).toList(),
                        ),
                      ),
                    );
            }
            return Container();
          },
        );
      },
    );
  }
}

class _CartBagWidget extends StatelessWidget {
  _CartBagWidget({
    required this.index,
    required this.cartEntity,
    required this.wordItems,
  });

  final int index;
  final CartEntity cartEntity;
  final List<WordEntity> wordItems;

  final bagNameNotifier = ValueNotifier("");

  void _onTapWordCartItem(BuildContext context, WordEntity entity) {
    context.showBottomSheet(
      child: WordDetailBottomSheet(wordEntity: entity),
    );
  }

  void _onSelectMenu(CartBagMenu item, BuildContext context) {
    switch (item) {
      case CartBagMenu.rename:
        _onRenameCartBag(context);
        break;
      case CartBagMenu.expand:
        _onExpandCartBag(context);
        break;
      case CartBagMenu.remove:
        _onRemoveCartBag(context);
        break;
      case CartBagMenu.known:
        _onMarkAsKnown(context);
        break;
      default:
    }
  }

  Future<void> _onMarkAsKnown(BuildContext context) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.cart_mark_all_as_known.tr(),
      subtitle: LocaleKeys.cart_mark_all_as_known_content.tr(),
      onAccept: () async {
        final uid = context.read<AuthBloc>().state.user?.uid;
        if (uid != null) {
          final wordsOfBag = cartEntity.bags[index].words;
          await Future.wait([
            context.read<KnownWordCubit>().addKnownWordList(uid, wordsOfBag),
            context
                .read<CartCubit>()
                .deleteCartBag(uid, cartEntity, cartEntity.bags[index]),
          ]);
        }
      },
    );
  }

  Future<void> _onRenameCartBag(BuildContext context) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.cart_rename_this_bag_title.tr(),
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
        final uid = context.read<AuthBloc>().state.user?.uid;
        if (uid != null) {
          await Navigators().showLoading(
            tasks: [
              context.read<CartCubit>().renameCartBag(
                    uid,
                    name.isEmpty ? LocaleKeys.cart_my_bag_default.tr() : name,
                    cartEntity,
                    cartEntity.bags[index],
                  ),
            ],
          );
        }
      },
    );
  }

  Future<void> _onRemoveCartBag(BuildContext context) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.cart_remove_cart_bag.tr(),
      subtitle: LocaleKeys.cart_remove_cart_bag_content.tr(args: [
        LocaleKeys.activity_word.plural(cartEntity.bags[index].words.length)
      ]),
      onAccept: () async {
        final uid = context.read<AuthBloc>().state.user?.uid;
        if (uid != null) {
          await context
              .read<CartCubit>()
              .deleteCartBag(uid, cartEntity, cartEntity.bags[index]);
        }
      },
    );
  }

  Future<void> _onRemoveWordItem(
      BuildContext context, WordEntity wordEntity) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.cart_remove_word_title.tr(),
      subtitle: LocaleKeys.cart_remove_word_content.tr(
        args: [wordEntity.word.toLowerCase()],
      ),
      onAccept: () async {
        final uid = context.read<AuthBloc>().state.user?.uid;
        if (uid != null) {
          await context.read<CartCubit>().deleteWordItem(
              uid, wordEntity, cartEntity, cartEntity.bags[index]);
        }
      },
    );
  }

  Future<void> _onExpandCartBag(BuildContext context) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.cart_expand_this_bag.tr(),
      subtitle: LocaleKeys.cart_expand_this_bag_content.tr(),
      onAccept: () async {
        final uid = context.read<AuthBloc>().state.user?.uid;
        if (uid != null) {
          Navigators().showLoading(
            tasks: [
              context
                  .read<CartCubit>()
                  .expandCartBag(uid, cartEntity, cartEntity.bags[index])
            ],
            onFinish: () =>
                Navigators().currentContext!.read<CartBagCubit>().getCartBag(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w)
          .copyWith(top: index == 0 ? 20.h : null),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(.8),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextCustom(
                  cartEntity.bags[index].label,
                  style: context.textStyle.bodyM.bold.white,
                ),
              ),
              const Gap(width: 12),
              _buildPopupMenu(context),
            ],
          ),
          const Gap(height: 5),
          TextCustom(
            cartEntity.bags[index].dateTime.ddMMyyyyHHmmaa,
            style: context.textStyle.caption.grey300,
          ),
          DashedLineCustom(
            margin: EdgeInsets.only(top: 12.h, bottom: 15.h),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: wordItems
                .map(
                  (e) => Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: WordSmallCardWidget(
                      onTap: () => _onTapWordCartItem(context, e),
                      onRemove: () => _onRemoveWordItem(context, e),
                      text: e.word.toLowerCase(),
                      textStyle: context.textStyle.bodyS.bold.primaryDark,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      surfaceTintColor: context.theme.cardColor,
      onSelected: (val) => _onSelectMenu(val, context),
      itemBuilder: (context) => [
        _buildMenuItem(
          context: context,
          icon: Icons.edit_note_rounded,
          text: LocaleKeys.cart_rename_menu.tr(),
          value: CartBagMenu.rename,
        ),
        _buildMenuItem(
          context: context,
          icon: Icons.playlist_add_rounded,
          text: LocaleKeys.cart_expand_menu.tr(),
          value: CartBagMenu.expand,
        ),
        _buildMenuItem(
          context: context,
          icon: Icons.playlist_remove_rounded,
          text: LocaleKeys.cart_remove_menu.tr(),
          value: CartBagMenu.remove,
        ),
        _buildMenuItem(
          context: context,
          icon: Icons.playlist_add_check,
          text: LocaleKeys.cart_mark_all_as_known.tr(),
          value: CartBagMenu.known,
        ),
      ],
      child: const Icon(Icons.more_vert_rounded, color: Colors.white),
    );
  }

  PopupMenuItem<CartBagMenu> _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required CartBagMenu value,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Icon(
              icon,
              color: context.theme.primaryColor,
            ),
          ),
          TextCustom(
            text,
            style: context.textStyle.bodyS.bw,
          ),
        ],
      ),
    );
  }
}
