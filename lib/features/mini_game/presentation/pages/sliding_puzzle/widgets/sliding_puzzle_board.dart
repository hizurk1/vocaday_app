import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/constants/app_const.dart';
import '../../../../../../app/themes/app_color.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/widgets/widgets.dart';
import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/extensions/color.dart';

class SlidingPuzzleBoardWidget extends StatelessWidget {
  const SlidingPuzzleBoardWidget({
    super.key,
    required this.gridSize,
    required this.word,
    required this.list,
    required this.onTap,
  });

  final int gridSize;
  final String word;
  final List<String> list;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: cons.maxHeight > cons.maxWidth
                ? 1 / 1
                : cons.maxWidth / cons.maxHeight,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final text = list[index];
            final color = index < word.length && text == word[index]
                ? context.colors.green
                : context.theme.cardColor;
            return text == AppStringConst.slidingPuzzleEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () => onTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: color.darken(0.2),
                            width: 4.h,
                          ),
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                          bottom: Radius.circular(10.r),
                        ),
                        color: color,
                      ),
                      child: Center(
                        child: TextCustom(
                          text,
                          style: context.textStyle.titleM.bold.bw.copyWith(
                            color: index < word.length && text == word[index]
                                ? context.colors.white
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      );
    });
  }
}
