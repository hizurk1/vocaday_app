import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/themes/app_color.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/widgets.dart';
import '../../../../user_cart/presentation/widgets/cart_icon_widget.dart';
import '../../../domain/entities/user_entity.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class HomeTopAppBar extends StatelessWidget {
  const HomeTopAppBar({super.key, required this.bagKey});

  final GlobalKey bagKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h)
          .copyWith(right: 0),
      child: Row(
        children: [
          Expanded(
            child: _buildUserInfoTile(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: CartIconWidget(key: bagKey, marginRight: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoTile() {
    return BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
      selector: (state) => state is UserDataLoadedState ? state.entity : null,
      builder: (context, UserEntity? userEntity) {
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
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColor().red,
            ),
            child: TextCustom(
              LocaleKeys.user_data_point.plural(userEntity?.point ?? 0),
              style: context.textStyle.labelS.white,
            ),
          ),
        );
      },
    );
  }
}
