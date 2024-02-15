import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/cached_network_image.dart';
import '../../../../../app/widgets/list_tile_custom.dart';
import '../../../../../app/widgets/text.dart';
import '../../../domain/entities/user_entity.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class HomeTopAppBar extends StatelessWidget {
  const HomeTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            child: _buildUserInfoTile(),
          ),
          Container(
            color: Colors.transparent,
            width: 50,
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoTile() {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        UserEntity? userEntity;
        if (state is UserDataLoadedState) {
          userEntity = state.entity;
        }
        return ListTileCustom(
          leading: CachedNetworkImageCustom(
            url: userEntity?.avatar ?? '',
            size: 40,
          ),
          title: TextCustom(
            userEntity?.name ?? '',
            style: context.textStyle.bodyS.bold.bw,
          ),
          subTitle: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColor().red,
            ),
            child: TextCustom(
              LocaleKeys.user_data_point.plural(userEntity?.point ?? 0),
              style: context.textStyle.labelM.white,
            ),
          ),
        );
      },
    );
  }
}
