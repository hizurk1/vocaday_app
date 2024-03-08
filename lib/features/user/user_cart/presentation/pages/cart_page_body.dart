import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
import '../../domain/entities/cart_entity.dart';
import '../cubits/cart/cart_cubit.dart';

class CartPageBody extends StatefulWidget {
  const CartPageBody({
    super.key,
  });

  @override
  State<CartPageBody> createState() => _CartPageBodyState();
}

class _CartPageBodyState extends State<CartPageBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uid = context.read<AuthBloc>().state.user?.uid;
      if (uid != null) {
        await context.read<CartCubit>().getCart(uid);
      }
    });
  }

  Future<void> _onRefresh() async {
    final uid = context.read<AuthBloc>().state.user?.uid;
    if (uid != null) {
      await context.read<CartCubit>().getCart(uid);
      Navigators().showMessage(LocaleKeys.profile_everything_is_up_to_date.tr(),
          type: MessageType.success);
    }
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
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cartEntity.bags.length,
                  itemBuilder: (context, index) {
                    final wordItems = wordList
                        .where((e) =>
                            cartEntity.bags[index].words.contains(e.word))
                        .toList();
                    return _CartBagWidget(
                      index: index,
                      cartEntity: cartEntity,
                      wordItems: wordItems,
                    );
                  },
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
  const _CartBagWidget({
    required this.index,
    required this.cartEntity,
    required this.wordItems,
  });

  final int index;
  final CartEntity cartEntity;
  final List<WordEntity> wordItems;

  void _onTapWordCartItem(BuildContext context, WordEntity entity) {
    context.showBottomSheet(
      child: WordDetailBottomSheet(wordEntity: entity),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w)
          .copyWith(top: index == 0 ? 20.h : null),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
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
          const Gap(height: 5),
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.calendarOutline,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              Gap(width: 10.w),
              TextCustom(
                cartEntity.bags[index].dateTime.ddMMyyyyHHmmaa,
                style: context.textStyle.bodyS.bold.white,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _onRemoveCartBag(context),
                child: SvgPicture.asset(
                  Assets.icons.closeCircle,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          DashedLineCustom(
            margin: EdgeInsets.symmetric(vertical: 15.h).copyWith(top: 20.h),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: wordItems
                .map(
                  (e) => Padding(
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
}
