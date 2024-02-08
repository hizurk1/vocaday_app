import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../features/user/presentation/blocs/user_data/user_data_bloc.dart';
import '../../../../../themes/app_text_theme.dart';
import '../../../../../translations/translations.dart';
import '../../../../../widgets/cached_network_image.dart';
import '../../../../../widgets/gap.dart';
import '../../../../../widgets/text.dart';

class ProfilePersonalInfo extends StatelessWidget {
  const ProfilePersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoadedState) {
          return Container(
            padding: EdgeInsets.only(
              right: 30.w,
              left: 30.w,
              top: 30.h,
              bottom: 10.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CachedNetworkImageCustom(
                  url: state.entity.avatar ?? '',
                  size: 64,
                ),
                Gap(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextCustom(
                        state.entity.name,
                        style: context.textStyle.bodyM.bold.bw,
                      ),
                      Gap(height: 5.h),
                      TextCustom(
                        LocaleKeys.user_data_point.plural(state.entity.point),
                        style: context.textStyle.bodyS.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
