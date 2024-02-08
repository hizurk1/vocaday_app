import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/extensions/build_context.dart';
import '../../../../../constants/app_asset.dart';
import '../../../../../themes/app_color.dart';
import '../../../../../widgets/cached_network_image.dart';
import '../../../../../widgets/gap.dart';
import '../../../../../widgets/text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileTile(),
            _buildTabBarSelector(),
            Gap(height: 20.h * 1.25),
            SizedBox(
              height: context.screenHeight * 0.5 + 80.h,
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(),
                  Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildTopAppBar() {
    return AppBar(
      toolbarHeight: 52.h,
      elevation: 1,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(5.w),
          margin: EdgeInsets.only(left: 20.w),
          child: SvgPicture.asset(
            AppAssets.profileCheckUpdate,
          ),
        ),
      ),
      title: const TextCustom(
        "My profile",
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(5.w),
            margin: EdgeInsets.only(right: 20.w),
            child: SvgPicture.asset(
              AppAssets.profilePencil,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30.w,
        vertical: 30.h,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const CachedNetworkImageCustom(
            url: '',
            size: 64,
          ),
          Gap(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextCustom(
                  'Hieu',
                ),
                Gap(height: 5.h),
                const TextCustom(
                  'level',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarSelector() {
    return Container(
      height: 46.h,
      width: context.screenWidth,
      padding: EdgeInsets.all(4.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: context.colors.grey,
        border: Border.all(color: context.colors.grey.withOpacity(0.15)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: context.theme.dividerColor,
        labelStyle: context.textTheme.bodyMedium,
        unselectedLabelColor: context.colors.grey,
        unselectedLabelStyle: context.textTheme.bodyMedium,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: context.colors.background,
          boxShadow: [
            BoxShadow(
              color: context.colors.drawer,
              offset: const Offset(1, 1),
              blurRadius: 1,
            ),
          ],
        ),
        tabs: const [
          Tab(text: 'personal_info'),
          Tab(text: 'completion_progress'),
        ],
      ),
    );
  }
}
