import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/constants/app_asset.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/app_bar.dart';
import '../../../../../app/widgets/cached_network_image.dart';
import '../../../../../app/widgets/status_bar.dart';
import '../../../../../app/widgets/text.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class ProfileEditPersonalInfoPage extends StatelessWidget {
  const ProfileEditPersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBarCustom(
          enablePadding: true,
          leading: const BackButton(),
          textTitle: LocaleKeys.profile_edit_profile.tr(),
          action: TextButton(
            onPressed: () {},
            child: TextCustom(
              LocaleKeys.common_save.tr(),
              style: context.textStyle.bodyM.primary,
            ),
          ),
        ),
        body: BlocBuilder<UserDataCubit, UserDataState>(
          builder: (context, state) {
            if (state is UserDataLoadedState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAvatar(state.entity.avatar ?? '', context),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(String url, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CachedNetworkImageCustom(
              url: url,
              size: 72,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  color: context.colors.grey200,
                ),
                child: SvgPicture.asset(
                  AppAssets.camera,
                  colorFilter: ColorFilter.mode(
                    context.colors.grey600,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
