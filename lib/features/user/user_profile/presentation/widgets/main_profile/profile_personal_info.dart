import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/widgets.dart';
import '../../../domain/entities/user_entity.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class ProfilePersonalInfoTile extends StatelessWidget {
  const ProfilePersonalInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
      selector: (state) => state is UserDataLoadedState ? state.entity : null,
      builder: (context, UserEntity? userEntity) {
        return Container(
          padding: EdgeInsets.only(
            right: 20.w,
            left: 20.w,
            top: 30.h,
            bottom: 10.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CachedNetworkImageCustom(
                url: userEntity?.avatar,
                size: 64,
              ),
              Gap(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextCustom(
                      userEntity?.name ?? '',
                      style: context.textStyle.bodyM.bold.bw,
                    ),
                    Gap(height: 5.h),
                    TextCustom(
                      LocaleKeys.user_data_point.plural(userEntity?.point ?? 0),
                      style: context.textStyle.bodyS.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
