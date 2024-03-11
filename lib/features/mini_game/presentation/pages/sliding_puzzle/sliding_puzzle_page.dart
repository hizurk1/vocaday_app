import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/managers/navigation.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/color.dart';
import '../../../../../core/extensions/list.dart';
import '../../../../../core/extensions/string.dart';
import '../../../../../injection_container.dart';
import '../../../../authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../../domain/usecases/update_user_gold.dart';
import '../../../domain/usecases/update_user_point.dart';
import '../../cubits/sliding_puzzle/sliding_puzzle_cubit.dart';
import 'widgets/sliding_puzzle_board.dart';

// ignore: must_be_immutable
class SlidingPuzzlePage extends StatelessWidget {
  const SlidingPuzzlePage({
    super.key,
    required this.words,
  });

  final List<WordEntity> words;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SlidingPuzzleCubit(
        uid: context.read<AuthBloc>().state.user?.uid,
        words: words,
        updateUserPointUsecase: sl<UpdateUserPointUsecase>(),
        updateUserGoldUsecase: sl<UpdateUserGoldUsecase>(),
      )..generateList(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: context.colors.blue900.darken(.05),
          appBar: _buildAppBar(context),
          body: BlocBuilder<SlidingPuzzleCubit, SlidingPuzzleState>(
            builder: (context, state) {
              if (state.status == SlidingPuzzleStatus.loading) {
                return Center(
                    child: LottieBuilder.asset(Assets.jsons.loadingSandClock,
                        width: context.screenWidth / 4));
              }
              if (state.status == SlidingPuzzleStatus.error) {
                return ErrorPage(text: state.message ?? '');
              }
              if (state.status == SlidingPuzzleStatus.loaded) {
                return Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: SlidingPuzzleBoardWidget(
                        gridSize: state.gridSize,
                        word: words[state.index].word,
                        list: state.list.map((e) => e.toUpperCase()).toList(),
                        onTap: context.read<SlidingPuzzleCubit>().gridItemClick,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: _buildControls(state, context),
                    ),
                  ],
                );
              }
              if (state.status == SlidingPuzzleStatus.done) {
                return _buildSuccess(context, state.count);
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  Widget _buildSuccess(BuildContext context, int correct) {
    final point = correct * 2;
    final gold = 1 + correct ~/ AppValueConst.minWordInBagToPlay;

    return Scaffold(
      backgroundColor: context.colors.blue900.darken(.05),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LottieBuilder.asset(
                  correct > 0 ? Assets.jsons.trophy : Assets.jsons.sadStar,
                  height: context.screenHeight / 4,
                ),
                const Gap(height: 10),
                TextCustom(
                  LocaleKeys.game_correct_answer.tr(
                    args: ["$correct/${words.length}"],
                  ),
                  style: context.textStyle.bodyL.white,
                ),
                const Gap(height: 15),
                TextCustom(
                  LocaleKeys.game_congrats_you_got_point.tr(),
                  style: context.textStyle.titleM.bold.white,
                  maxLines: 2,
                ),
                const Gap(height: 10),
                TextCustom(
                  LocaleKeys.user_data_point.plural(point),
                  style: context.textStyle.headingS.bold.copyWith(
                    color: context.colors.green400,
                  ),
                ),
                if (correct > 0) ...[
                  const Gap(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.gold,
                        height: 30.h,
                        width: 30.w,
                      ),
                      const Gap(width: 5),
                      TextCustom(
                        "+$gold",
                        style: context.textStyle.bodyL.white.bold,
                      ),
                    ],
                  ),
                ],
                const Gap(height: 20),
                PushableButton(
                  onPressed: () => context.pop(),
                  text: LocaleKeys.common_back.tr(),
                  type: PushableButtonType.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBarCustom _buildAppBar(BuildContext context) {
    return AppBarCustom(
      transparent: true,
      leading: BlocBuilder<SlidingPuzzleCubit, SlidingPuzzleState>(
        builder: (context, state) {
          return state.status == SlidingPuzzleStatus.done
              ? const SizedBox()
              : BackButton(
                  color: context.colors.white,
                );
        },
      ),
      title: BlocBuilder<SlidingPuzzleCubit, SlidingPuzzleState>(
        builder: (context, state) {
          return state.status == SlidingPuzzleStatus.done
              ? const SizedBox()
              : TextCustom(
                  "${state.index + 1}/${words.length}",
                  style: context.textStyle.titleS.bold.white,
                );
        },
      ),
      action: Padding(
        padding: EdgeInsets.only(right: 5.w),
        child: BlocBuilder<SlidingPuzzleCubit, SlidingPuzzleState>(
          builder: (context, state) {
            final word = words[state.index];
            return state.status == SlidingPuzzleStatus.done
                ? const SizedBox()
                : TextButton(
                    onPressed: () {
                      final meaning = word.meanings.getRandom?.meaning ??
                          word.meanings.first.meaning;
                      Navigators().showDialogWithButton(
                        showIcon: false,
                        showAccept: false,
                        showCancel: false,
                        title: "${meaning.capitalizeFirstLetter}.",
                        maxLinesTitle: 10,
                      );
                    },
                    child: TextCustom(
                      LocaleKeys.game_hint.tr(),
                      style: context.textStyle.bodyM.white,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildControls(SlidingPuzzleState state, BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(
              Assets.jsons.cow,
              height: context.screenHeight / 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              width: context.screenWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.white,
                  width: 3.w,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextCustom(
                state.isCompleted
                    ? state.list
                        .join()
                        .substring(0, words[state.index].word.length)
                    : state.list
                        .join()
                        .replaceAll(AppStringConst.slidingPuzzleEmpty, "_"),
                style: context.textStyle.titleM.bold.white
                    .copyWith(letterSpacing: 5),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            if (state.isCompleted) ...[
              const Gap(height: 20),
              PushableButton(
                onPressed: () =>
                    context.read<SlidingPuzzleCubit>().onNextWord(),
                text: LocaleKeys.common_next.tr(),
                type: PushableButtonType.primary,
              ),
            ] else ...[
              const Gap(height: 15),
              TextButton(
                onPressed: () =>
                    context.read<SlidingPuzzleCubit>().onNextWord(),
                child: TextCustom(
                  LocaleKeys.common_skip.tr(),
                  style: context.textStyle.bodyL.bold.grey80,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
