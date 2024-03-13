import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/routes/route_manager.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/gap.dart';
import '../../../../../app/widgets/text.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/string.dart';
import '../../blocs/word_list/word_list_cubit.dart';

class ActivityLearnNewWordWidget extends StatelessWidget {
  const ActivityLearnNewWordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Material(
        borderRadius: BorderRadius.circular(16.r),
        color: context.bottomSheetBackground,
        child: InkWell(
          onTap: () => context.push(AppRoutes.listWord),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor.withOpacity(.8),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Assets.icons.store,
                            height: 16.h,
                            width: 16.w,
                            colorFilter: ColorFilter.mode(
                              context.colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Gap(width: 5),
                          BlocSelector<WordListCubit, WordListState, int?>(
                            selector: (state) {
                              return state is WordListLoadedState
                                  ? state.wordList.length
                                  : 0;
                            },
                            builder: (context, count) {
                              return TextCustom(
                                LocaleKeys.activity_word
                                    .plural(count ?? 0)
                                    .formatedThousand,
                                style: context.textStyle.labelM.white,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: context.theme.primaryColorDark,
                      size: 24.w,
                    )
                  ],
                ),
                const Gap(height: 10),
                TextCustom(
                  LocaleKeys.activity_word_store_title.tr(),
                  style: context.textStyle.bodyL.bw.bold,
                ),
                const Gap(height: 5),
                TextCustom(
                  LocaleKeys.activity_word_store_content.tr(),
                  style: context.textStyle.caption.grey80,
                  maxLines: 5,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
