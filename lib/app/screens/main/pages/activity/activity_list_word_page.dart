import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/cart/presentation/widgets/cart_icon_widget.dart';
import '../../../../../features/user/domain/entities/user_entity.dart';
import '../../../../../features/user/presentation/cubits/user_data/user_data_cubit.dart';
import '../../../../../features/word/domain/entities/word_entity.dart';
import '../../../../../features/word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../../../constants/app_const.dart';
import '../../../../routes/route_manager.dart';
import '../../../../themes/app_color.dart';
import '../../../../themes/app_text_theme.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/gap.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/status_bar.dart';
import '../../../../widgets/text.dart';

class ActivityListWordPage extends StatelessWidget {
  const ActivityListWordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: const AppBarCustom(
          leading: BackButton(),
          textTitle: "Word store",
          action: CartIconWidget(marginRight: 15),
        ),
        body: BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
          selector: (state) {
            return state is UserDataLoadedState ? state.entity : null;
          },
          builder: (context, UserEntity? userEntity) {
            if (userEntity == null) {
              return const LoadingIndicatorPage();
            }
            return BlocSelector<WordListCubit, WordListState, List<WordEntity>>(
              selector: (state) {
                return state is WordListLoadedState ? state.wordList : [];
              },
              builder: (context, List<WordEntity> wordList) {
                return ListView(
                  children: AppStringConst.alphabet.split("").map(
                    (title) {
                      final filtedList = wordList
                          .where((e) => e.word.toLowerCase().startsWith(title))
                          .toList()
                        ..shuffle();
                      return GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.flashCard, extra: {
                            'title': title,
                            'words': filtedList,
                          });
                        },
                        child: _ActivityListWordCardWidget(
                          title: title,
                          value: Random().nextInt(filtedList.length),
                          total: filtedList.length,
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            );
          },
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
