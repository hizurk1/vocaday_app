import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../../app/themes/app_color.dart';
import '../../../../../word/domain/entities/word_entity.dart';
import '../../../../../word/presentation/blocs/word_list/word_list_cubit.dart';
import '../../cubits/known/known_word_cubit.dart';

class KnownWordIconWidget extends StatelessWidget {
  const KnownWordIconWidget({
    super.key,
    required this.knewKey,
    required this.word,
  });

  final GlobalKey knewKey;
  final String word;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<KnownWordCubit, KnownWordState, List<String>>(
      selector: (state) => state is KnownWordLoadedState
          ? state.words.map((e) => e.word).toList()
          : [],
      builder: (context, list) {
        return list.contains(word)
            ? const SizedBox()
            : BlocSelector<WordListCubit, WordListState, List<WordEntity>>(
                selector: (state) =>
                    state is WordListLoadedState ? state.wordList : [],
                builder: (context, list) {
                  return GestureDetector(
                    onTap: () =>
                        context.read<KnownWordCubit>().addKnownWord(word, list),
                    child: Container(
                      margin: EdgeInsets.only(left: 15.w),
                      child: SvgPicture.asset(
                        Assets.icons.checkCircle,
                        key: knewKey,
                        height: 28.h,
                        colorFilter: ColorFilter.mode(
                            context.colors.grey400, BlendMode.srcIn),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
