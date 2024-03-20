import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../../../app/themes/app_color.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/widgets.dart';
import '../../../../../../core/extensions/build_context.dart';
import '../../../../../word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../cubits/known/known_word_cubit.dart';

class ProfileCompletionProgressKnownsChartWidget extends StatelessWidget {
  const ProfileCompletionProgressKnownsChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WordListCubit, WordListState, int>(
      selector: (state) =>
          state is WordListLoadedState ? state.wordList.length : 0,
      builder: (context, words) {
        if (words == 0) {
          return const SizedBox();
        }
        return BlocSelector<KnownWordCubit, KnownWordState, int>(
          selector: (state) =>
              state is KnownWordLoadedState ? state.words.length : 0,
          builder: (context, int knowns) {
            return CircularPercentIndicator(
              radius: context.screenWidth / 4,
              percent: knowns / words,
              lineWidth: 20.w,
              animateFromLastPercent: true,
              // circularStrokeCap: CircularStrokeCap.round,
              progressColor: context.colors.green,
              backgroundColor: context.isDarkTheme
                  ? context.colors.grey900
                  : context.colors.grey150,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$knowns",
                          style: context.textStyle.bodyL.primary.bold,
                        ),
                        TextSpan(
                          text: "/$words",
                          style: context.textStyle.caption.grey.bold,
                        ),
                      ],
                    ),
                  ),
                  TextCustom(
                    LocaleKeys.known_knowns.tr(),
                    style: context.textStyle.caption.bold.grey,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
