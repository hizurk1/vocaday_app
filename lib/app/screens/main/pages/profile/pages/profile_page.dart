import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/extensions/build_context.dart';
import '../../../../../constants/app_asset.dart';
import '../../../../../translations/translations.dart';
import '../../../../../widgets/app_bar.dart';
import '../../../../../widgets/sliver_tab_view.dart';
import '../../../../../widgets/tab_bar_custom.dart';
import '../../../../../widgets/text.dart';
import '../widgets/profile_personal_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBarCustom(
        textTitle: LocaleKeys.profile_profile_title.tr(),
        action: GestureDetector(
          onTap: () {},
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
          topChild: const ProfilePersonalInfo(),
          tabBar: TabBarCustom(
            tabs: [
              Tab(text: LocaleKeys.profile_personal_info.tr()),
              Tab(text: LocaleKeys.profile_completion_progress.tr()),
            ],
          ),
          tabBarView: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              Center(child: TextCustom('Info')),
              Center(child: TextCustom('Progress')),
            ],
          ),
        ),
      ),
    );
  }
}
