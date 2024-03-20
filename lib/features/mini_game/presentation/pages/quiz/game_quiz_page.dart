// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/managers/navigation.dart';
import '../../../../../app/routes/route_manager.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/select_option_tile.dart';
import '../../../../../app/widgets/timer_count_down.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/color.dart';
import '../../../../../core/extensions/list.dart';
import '../../../../../injection_container.dart';
import '../../../../authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../cubits/quiz/game_quiz_cubit.dart';

class QuizEntity {
  final String word;
  final String question;
  final List<String> answers;
  String selectedAnswer;
  QuizEntity({
    required this.word,
    required this.question,
    required this.answers,
    this.selectedAnswer = '',
  });
}

class GameQuizPage extends StatefulWidget {
  const GameQuizPage({super.key, required this.words});

  final List<WordEntity> words;

  @override
  State<GameQuizPage> createState() => _GameQuizPageState();
}

class _GameQuizPageState extends State<GameQuizPage> {
  final ValueNotifier<int> currentQuestion = ValueNotifier(0);
  final ValueNotifier<int> selectedIndex = ValueNotifier(-1);
  late List<QuizEntity> quizs;
  late int timeDuration;

  @override
  void initState() {
    super.initState();

    timeDuration = AppValueConst.timeForQuiz * widget.words.length;
    final list = widget.words.map((e) => e.word).toList();
    quizs = List<QuizEntity>.generate(
      widget.words.length,
      (index) {
        final answers = List<String>.from(list)
          ..remove(widget.words[index].word)
          ..shuffle();
        final meaningEntity = widget.words[index].meanings.getRandom ??
            widget.words[index].meanings.first;

        return QuizEntity(
          word: widget.words[index].word,
          question:
              "(${meaningEntity.type.toLowerCase()}) ${meaningEntity.meaning}",
          answers: answers.take(3).toList()
            ..insert(
              Random().nextInt(4),
              widget.words[index].word,
            ),
        );
      },
    );
  }

  _onCompleteQuiz(BuildContext context) async {
    final correct =
        quizs.where((element) => element.selectedAnswer == element.word).length;
    final gold = correct ~/ AppValueConst.minWordInBagToPlay +
        (correct == quizs.length ? 2 : 0);

    final uid = context.read<AuthBloc>().state.user?.uid;
    if (uid != null) {
      await context.read<GameQuizCubit>().calculateResult(
            uid: uid,
            point: correct,
            gold: gold,
          );
    }
  }

  void _onNextQuiz(BuildContext context, int current) {
    if (current < quizs.length - 1) {
      if (quizs[current].selectedAnswer.isNotEmpty) {
        currentQuestion.value++;
        selectedIndex.value = -1;
      }
    } else {
      _onCompleteQuiz(context);
    }
  }

  _onBack() async {
    final res = await Navigators().showDialogWithButton(
      title: LocaleKeys.game_quit_message.tr(),
      acceptText: LocaleKeys.common_yes_ofc.tr(),
    );
    if (res != null && res) {
      Navigators().popDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _onBack(),
      child: BlocProvider(
        create: (_) => sl<GameQuizCubit>(),
        child: Builder(builder: (context) {
          return StatusBar(
            child: BlocBuilder<GameQuizCubit, GameQuizState>(
              builder: (context, state) {
                if (state.status == GameQuizStatus.loading) {
                  return Scaffold(
                    backgroundColor: context.colors.blue900.darken(.05),
                    body: const LoadingIndicatorPage(),
                  );
                }
                if (state.status == GameQuizStatus.error) {
                  return Scaffold(
                    backgroundColor: context.colors.blue900.darken(.05),
                    body: ErrorPage(text: state.message ?? ''),
                  );
                }
                if (state.status == GameQuizStatus.success) {
                  final correct =
                      quizs.where((e) => e.selectedAnswer == e.word).length;

                  return _buildSuccess(context, correct);
                }

                return Scaffold(
                  backgroundColor: context.colors.blue900.darken(.05),
                  appBar: _buildAppBar(context),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: currentQuestion,
                            builder: (context, value, _) {
                              return LinearProgressIndicator(
                                value: (value + 1) / quizs.length,
                                color: context.colors.green,
                                backgroundColor:
                                    context.colors.grey.withOpacity(.15),
                                borderRadius: BorderRadius.circular(8.r),
                                minHeight: 12.h,
                              );
                            },
                          ),
                          const Gap(height: 20),
                          _buildCardQuestionAnswer(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, int correct) {
    final gold = correct ~/ AppValueConst.minWordInBagToPlay +
        (correct == quizs.length ? 2 : 0);
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
                  Assets.jsons.trophy,
                  height: context.screenHeight / 4,
                ),
                TextCustom(
                  LocaleKeys.game_correct_answer.tr(
                    args: ["$correct/${quizs.length}"],
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
                  LocaleKeys.user_data_point.plural(correct),
                  style: context.textStyle.headingS.bold.copyWith(
                    color: context.colors.green400,
                  ),
                ),
                if (correct ~/ AppValueConst.minWordInBagToPlay > 0) ...[
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
                  onPressed: () => context.pushReplacement(
                    AppRoutes.quizSummery,
                    extra: quizs,
                  ),
                  text: LocaleKeys.game_view_result.tr(),
                ),
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

  Widget _buildCardQuestionAnswer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.theme.cardColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: ValueListenableBuilder(
        valueListenable: currentQuestion,
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.images.questionMark,
              height: 30.h,
              width: 30.w,
            ),
            const Gap(width: 8),
            Expanded(
              child: TextCustom(
                LocaleKeys.game_select_your_answer.tr(),
                style: context.textStyle.bodyS.grey,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: TimeCountDownWidget(
                onFinish: () {
                  _onCompleteQuiz(context);
                },
                durationInSeconds: timeDuration,
                style: context.textStyle.caption.white,
              ),
            ),
          ],
        ),
        builder: (context, current, row) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              row!,
              const Gap(height: 10),
              TextCustom(
                "${quizs[current].question}.",
                textAlign: TextAlign.justify,
                maxLines: 10,
              ),
              const Gap(height: 15),
              ValueListenableBuilder(
                valueListenable: selectedIndex,
                builder: (context, selected, _) {
                  return Column(
                    children: quizs[current]
                        .answers
                        .mapIndexed((index, e) => SelectOptionTileWidget(
                              onTap: () {
                                quizs[current].selectedAnswer = e;
                                selectedIndex.value = index;
                              },
                              isSelected: quizs[current].selectedAnswer == e ||
                                  selected == index,
                              style: context.textStyle.bodyS.bw.bold,
                              text: e.toLowerCase(),
                            ))
                        .toList(),
                  );
                },
              ),
              const Gap(height: 15),
              _buildButtons(context, current),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context, int current) {
    return SizedBox(
      width: context.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: current == 0
                ? const SizedBox()
                : TextButton(
                    onPressed: () {
                      currentQuestion.value--;
                      selectedIndex.value = -1;
                    },
                    child: TextCustom(
                      LocaleKeys.common_back.tr(),
                      style: context.textStyle.bodyM.bold.bw,
                    ),
                  ),
          ),
          ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, selected, _) {
              return SizedBox(
                width: context.screenWidth / 3,
                child: PushableButton(
                  onPressed: () => _onNextQuiz(context, current),
                  width: context.screenWidth / 3,
                  type: quizs[current].selectedAnswer.isNotEmpty ||
                          current == quizs.length - 1
                      ? PushableButtonType.primary
                      : PushableButtonType.grey,
                  text: current == quizs.length - 1
                      ? LocaleKeys.common_done.tr()
                      : LocaleKeys.common_next.tr(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  AppBarCustom _buildAppBar(BuildContext context) {
    return AppBarCustom(
      transparent: true,
      // enablePadding: true,
      leading: BackButton(
        style: ButtonStyle(
            iconSize: MaterialStateProperty.all(24.w),
            iconColor: MaterialStateProperty.all(context.colors.white)),
      ),
      title: ValueListenableBuilder(
        valueListenable: currentQuestion,
        builder: (context, value, _) {
          return TextCustom(
            LocaleKeys.game_question_th.tr(
              args: [(value + 1).toString(), quizs.length.toString()],
            ),
            style: context.textStyle.bodyM.bold.white,
            textAlign: TextAlign.center,
          );
        },
      ),
      action: Padding(
        padding: EdgeInsets.only(right: 5.w),
        child: ValueListenableBuilder(
          valueListenable: currentQuestion,
          builder: (context, value, _) {
            if (value >= quizs.length - 1) {
              return SizedBox(width: 60.w);
            }
            return TextButton(
              onPressed: () {
                currentQuestion.value++;
                selectedIndex.value = -1;
              },
              child: TextCustom(
                LocaleKeys.common_skip.tr(),
                style: context.textStyle.bodyS.white,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
