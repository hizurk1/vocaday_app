import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/user/user_profile/presentation/cubits/user_data/user_data_cubit.dart';
import '../../../../../features/user/user_profile/presentation/pages/main_profile/profile_edit_user_info_bottom_sheet.dart';
import '../../../../../features/user/user_profile/presentation/pages/main_profile/profile_personal_info_page_view.dart';
import '../../../../../features/user/user_profile/presentation/widgets/main_profile/profile_personal_info.dart';
import '../../../../constants/gen/assets.gen.dart';
import '../../../../managers/navigation.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/sliver_tab_view.dart';
import 'profile_completion_progress_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _onRefresh() async {
    Navigators().showLoading(
      tasks: [
        Future.delayed(Durations.extralong2, () {
          Navigators().showMessage(
            LocaleKeys.profile_everything_is_up_to_date.tr(),
            type: MessageType.success,
          );
        })
      ],
    );
  }

  void _onEditPressed(BuildContext context) {
    final state = context.read<UserDataCubit>().state;
    if (state is UserDataErrorState) {
      Navigators().showMessage(state.message, type: MessageType.error);
    }
    if (state is UserDataLoadedState) {
      context.showBottomSheet(
        child: ProfileEditUserInfoBottomSheet(
          userEntity: state.entity,
          initialHeight: 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBarCustom(
        textTitle: LocaleKeys.profile_profile_title.tr(),
        action: GestureDetector(
          onTap: () => _onEditPressed(context),
          child: Container(
            padding: EdgeInsets.all(5.w),
            margin: EdgeInsets.only(right: 20.w),
            child: SvgPicture.asset(
              Assets.icons.pencil,
              height: 25.h,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColorDark,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      body: SliverTabView(
        onRefresh: _onRefresh,
        numberOfTabs: 2,
        // physics: const BouncingScrollPhysics(),
        topChild: const ProfilePersonalInfoTile(),
        tabs: [
          Tab(text: LocaleKeys.profile_personal_info.tr()),
          Tab(text: LocaleKeys.profile_completion_progress.tr()),
        ],
        tabBarView: const TabBarView(
          physics: ClampingScrollPhysics(),
          children: [
            ProfilePersonalInfoPage(),
            ProfileCompletionProgressPage(),
          ],
        ),
      ),
    );
  }
}
