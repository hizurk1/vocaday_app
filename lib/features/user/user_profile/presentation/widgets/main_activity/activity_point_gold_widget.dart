import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../../app/managers/language.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/gap.dart';
import '../../../../../../app/widgets/text.dart';
import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/extensions/string.dart';
import '../../../domain/entities/user_entity.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class ActivityPointGoldWidget extends StatelessWidget {
  const ActivityPointGoldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageCubit>();
    return BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
      selector: (state) {
        return state is UserDataLoadedState ? state.entity : null;
      },
      builder: (context, entity) {
        return SafeArea(
          bottom: false,
          child: SizedBox(
            height: context.screenHeight / 3,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    Assets.images.toTheGoals,
                    fit: BoxFit.contain,
                    height: context.screenHeight * 0.3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextCustom(
                        LocaleKeys.activity_you_got_points.tr(),
                        style: context.textStyle.titleL.white,
                      ),
                      TextCustom(
                        (entity?.point ?? 0).toString().formatedThousand,
                        style: context.textStyle.headingXL.bold.copyWith(
                          color: Colors.yellow,
                        ),
                      ),
                      TextCustom(
                        LocaleKeys.user_data_point
                            .plural(entity?.point ?? 0)
                            .split(' ')
                            .last,
                        style: context.textStyle.titleL.white,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Assets.icons.gold,
                          height: 30.h,
                          width: 30.w,
                        ),
                        const Gap(width: 5),
                        TextCustom(
                          "x${entity?.gold ?? 0}",
                          style: context.textStyle.bodyL.white.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
