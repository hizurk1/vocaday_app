import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../../features/user/user_cart/presentation/cubits/cart/cart_cubit.dart';
import '../../../../../features/user/user_cart/presentation/cubits/cart_bag/cart_bag_cubit.dart';
import '../../../../../features/user/user_cart/presentation/widgets/cart_icon_widget.dart';
import '../../../../../features/word/domain/entities/word_entity.dart';
import '../../../../../features/word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../../../../injection_container.dart';
import '../../../../constants/app_const.dart';
import '../../../../managers/shared_preferences.dart';
import '../../../../routes/route_manager.dart';
import '../../../../themes/app_color.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/widgets.dart';

class ActivityWordStorePage extends StatefulWidget {
  const ActivityWordStorePage({super.key});

  @override
  State<ActivityWordStorePage> createState() => _ActivityWordStorePageState();
}

class _ActivityWordStorePageState extends State<ActivityWordStorePage> {
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

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBarCustom(
          leading: BackButton(
            style: ButtonStyle(iconSize: MaterialStateProperty.all(24.r)),
          ),
          textTitle: LocaleKeys.activity_vocab_store.tr(),
          action: const CartIconWidget(marginRight: 15),
        ),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: BlocSelector<WordListCubit, WordListState, List<WordEntity>>(
            selector: (state) {
              return state is WordListLoadedState ? state.wordList : [];
            },
            builder: (context, List<WordEntity> wordList) {
              if (wordList.isEmpty) {
                return const LoadingIndicatorPage();
              }
              return BlocBuilder<CartBagCubit, CartBagState>(
                buildWhen: (previous, current) =>
                    current.status == CartBagStatus.loaded,
                builder: (context, _) {
                  return BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      if (state is! CartLoadedState) {
                        return const LoadingIndicatorPage();
                      } else {
                        final bags = (sl<SharedPrefManager>().getCartBags +
                                state.entity.bags
                                    .expand((bag) => bag.words)
                                    .toList())
                            .toSet();

                        final excludeBagList = wordList
                            .whereNot((e) => bags.contains(e.word))
                            .toList();

                        if (excludeBagList.isEmpty) {
                          return const LoadingIndicatorPage();
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: AppStringConst.alphabet.split("").map(
                              (title) {
                                final filtedList = excludeBagList
                                    .where((e) =>
                                        e.word.toLowerCase().startsWith(title))
                                    .toList()
                                  ..shuffle();
                                final excludeKnown = filtedList.whereNot((e) =>
                                    sl<SharedPrefManager>()
                                        .getKnownWords
                                        .contains(e.word));

                                return GestureDetector(
                                  onTap: () async {
                                    await context
                                        .push(AppRoutes.flashCard, extra: {
                                      'title': title,
                                      'words': excludeKnown.toList(),
                                    });
                                    if (mounted) setState(() {});
                                  },
                                  child: _ActivityListWordCardWidget(
                                    title: title,
                                    value:
                                        filtedList.length - excludeKnown.length,
                                    total: filtedList.length,
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ActivityListWordCardWidget extends StatelessWidget {
  const _ActivityListWordCardWidget({
    required this.title,
    required this.value,
    required this.total,
  });

  final String title;
  final int value;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            offset: const Offset(0, 1),
            blurRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TextCustom(
                title,
                style: context.textStyle.bodyL.bold.bw,
              ),
              const Spacer(),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: "$value",
                  style: context.textStyle.bodyS.primaryDark.bold,
                ),
                TextSpan(
                  text: "/",
                  style: context.textStyle.bodyS.bw,
                ),
                TextSpan(
                  text: "$total",
                  style: context.textStyle.bodyS.bw,
                ),
              ]))
            ],
          ),
          const Gap(height: 15),
          LinearProgressIndicator(
            value: value / total,
            color: context.colors.blue,
            backgroundColor: context.greyColor.withOpacity(.35),
            borderRadius: BorderRadius.circular(4.r),
            minHeight: 8.h,
          ),
        ],
      ),
    );
  }
}
