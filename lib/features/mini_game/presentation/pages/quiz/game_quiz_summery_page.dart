import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/select_option_tile.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/color.dart';
import 'game_quiz_page.dart';

class GameQuizSummeryPage extends StatelessWidget {
  GameQuizSummeryPage({super.key, required this.quizs});

  final List<QuizEntity> quizs;
  final ValueNotifier<int> currentQuestion = ValueNotifier(0);

  void _onNextQuiz(BuildContext context, int current) {
    if (current < quizs.length - 1) {
      currentQuestion.value++;
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.colors.blue900.darken(.05),
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: currentQuestion,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: (value + 1) / quizs.length,
                      color: context.colors.green,
                      backgroundColor: context.colors.grey.withOpacity(.15),
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
        builder: (context, current, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(
                    LocaleKeys.game_result.tr(),
                    style: context.textStyle.bodyL.bold.bw,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color:
                          (quizs[current].word == quizs[current].selectedAnswer
                                  ? context.colors.green
                                  : context.colors.red)
                              .withOpacity(.75),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: TextCustom(
                      quizs[current].word == quizs[current].selectedAnswer
                          ? LocaleKeys.game_correct.tr()
                          : LocaleKeys.game_incorrect.tr(),
                      style: context.textStyle.bodyS.bold.bw,
                    ),
                  ),
                ],
              ),
              const Gap(height: 10),
              TextCustom(
                "${quizs[current].question}.",
                textAlign: TextAlign.justify,
                maxLines: 10,
              ),
              const Gap(height: 15),
              Column(
                children: quizs[current]
                    .answers
                    .mapIndexed((index, e) => SelectOptionTileWidget(
                          onTap: () {},
                          isSelected: quizs[current].selectedAnswer == e ||
                              quizs[current].word == e,
                          style: context.textStyle.bodyS.bw.bold,
                          text: e.toLowerCase(),
                          color: quizs[current].word == e
                              ? context.colors.green
                              : quizs[current].selectedAnswer == e
                                  ? context.colors.red
                                  : context.theme.dividerColor.withOpacity(.3),
                        ))
                    .toList(),
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
                    },
                    child: TextCustom(
                      LocaleKeys.common_back.tr(),
                      style: context.textStyle.bodyM.bold.bw,
                    ),
                  ),
          ),
          SizedBox(
            width: context.screenWidth / 3,
            child: PushableButton(
              onPressed: () => _onNextQuiz(context, current),
              width: context.screenWidth / 3,
              text: current == quizs.length - 1
                  ? LocaleKeys.common_done.tr()
                  : LocaleKeys.common_next.tr(),
            ),
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
      action: SizedBox(width: 50.w),
    );
  }
}
