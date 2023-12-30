import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/themes/app_color.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/cached_network_image.dart';
import '../../../../app/widgets/text.dart';
import '../blocs/user_data/user_data_bloc.dart';

class MenuDrawerTopInfo extends StatelessWidget {
  const MenuDrawerTopInfo({super.key, required this.onClosed});

  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoadedState) {
          return ListTile(
            leading: CachedNetworkImageCustom(
              url: state.entity.avatar ?? '',
              size: 40,
            ),
            title: TextCustom(
              state.entity.name,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
            ),
            subtitle: TextCustom(
              LocaleKeys.user_data_point.plural(state.entity.point),
              fontSize: 13,
              color: AppColor.grey,
            ),
            trailing: GestureDetector(
              onTap: onClosed,
              child: SizedBox(
                height: 25.h,
                width: 25.w,
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
