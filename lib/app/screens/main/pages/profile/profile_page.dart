import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/user/presentation/pages/main_profile/profile_personal_info_page.dart';
import '../../../../../features/user/presentation/widgets/main_profile/profile_personal_info.dart';
import '../../../../constants/app_asset.dart';
import '../../../../routes/route_manager.dart';
import '../../../../translations/translations.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/sliver_tab_view.dart';
import '../../../../widgets/tab_bar_custom.dart';
import 'profile_completion_progress_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBarCustom(
        textTitle: LocaleKeys.profile_profile_title.tr(),
        action: GestureDetector(
          onTap: () => context.push(AppRoutes.profileEdit),
          child: Container(
            padding: EdgeInsets.all(5.w),
            margin: EdgeInsets.only(right: 20.w),
            child: SvgPicture.asset(
              AppAssets.profilePencil,
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: SliverTabView(
          onRefresh: () async {
            await Future.delayed(Durations.extralong2);
          },
          topChild: const ProfilePersonalInfoTile(),
          tabBar: TabBarCustom(
            tabs: [
              Tab(text: LocaleKeys.profile_personal_info.tr()),
              Tab(text: LocaleKeys.profile_completion_progress.tr()),
            ],
          ),
          tabBarView: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfilePersonalInfoPage(),
              ProfileCompletionProgressPage(),
            ],
          ),
        ),
      ),
    );
  }
}
