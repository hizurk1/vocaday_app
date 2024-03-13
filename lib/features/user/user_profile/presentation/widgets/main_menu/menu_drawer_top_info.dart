import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/themes/app_color.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/cached_network_image.dart';
import '../../../../../../app/widgets/text.dart';
import '../../../domain/entities/user_entity.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class MenuDrawerTopInfo extends StatelessWidget {
  const MenuDrawerTopInfo({super.key, required this.onClosed});

  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
      selector: (state) => state is UserDataLoadedState ? state.entity : null,
      builder: (context, UserEntity? userEntity) {
        return ListTile(
          leading: CachedNetworkImageCustom(
            url: userEntity?.avatar ?? '',
            size: 40,
          ),
          title: TextCustom(
            userEntity?.name ?? '',
            style: context.textStyle.bodyS.copyWith(
              color: context.colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: TextCustom(
            LocaleKeys.user_data_point.plural(userEntity?.point ?? 0),
            style: context.textStyle.bodyS.grey,
          ),
          trailing: GestureDetector(
            onTap: onClosed,
            child: Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 25.r,
            ),
          ),
        );
      },
    );
  }
}
