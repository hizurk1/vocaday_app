import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/date_time.dart';
import '../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../features/user/user_cart/presentation/cubits/cart/cart_cubit.dart';
import '../../../features/word/domain/entities/word_entity.dart';
import '../../../features/word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../../features/word/presentation/pages/word_detail_bottom_sheet.dart';
import '../../constants/gen/assets.gen.dart';
import '../../themes/app_text_theme.dart';
import '../../translations/translations.dart';
import '../../widgets/widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

  void _onTapWordCartItem(WordEntity entity) {
    context.showBottomSheet(
      child: WordDetailBottomSheet(wordEntity: entity),
    );
  }

  Future<void> _onRefresh() async {
    final uid = context.read<AuthBloc>().state.user?.uid;
    if (uid != null) {
      await context.read<CartCubit>().getCart(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBarCustom(
          leading: const BackButton(),
          textTitle: LocaleKeys.cart_cart.tr(),
        ),
        body: BlocSelector<WordListCubit, WordListState, List<WordEntity>>(
          selector: (state) =>
              state is WordListLoadedState ? state.wordList : [],
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
                      itemCount: cartEntity.bags.length,
                      itemBuilder: (context, index) {
                        final wordItems = wordList.where((e) =>
                            cartEntity.bags[index].words.contains(e.word));
                        return Container(
                          margin: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 20.w)
                              .copyWith(top: index == 0 ? 20.h : null),
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: context.theme.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: context.shadowColor.withOpacity(.5),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                                    cartEntity
                                        .bags[index].dateTime.ddMMyyyyHHmmaa,
                                    style: context.textStyle.bodyS.bold.white,
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    Assets.icons.closeCircle,
                                    height: 20.h,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                              DashedLineCustom(
                                margin: EdgeInsets.symmetric(vertical: 15.h),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: wordItems
                                    .map(
                                      (e) => Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        child: WordSmallCardWidget(
                                          onTap: () => _onTapWordCartItem(e),
                                          onRemove: () {},
                                          text: e.word.toLowerCase(),
                                          textStyle: context
                                              .textStyle.bodyS.bold.primaryDark,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            );
          },
        ),
      ),
    );
  }
}
