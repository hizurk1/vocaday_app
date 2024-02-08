import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../../core/extensions/color.dart';
import '../../../../features/user/presentation/widgets/menu_drawer_top_info.dart';
import '../../../themes/app_color.dart';
import '../../../widgets/gap.dart';
import 'menu_drawer_tile_list.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
    required this.onClosed,
  });

  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.drawer.darken(
        context.isDarkTheme ? 0.05 : 0,
      ),
      body: Container(
        width: context.screenWidth * 0.65,
        height: context.screenHeight,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.h,
                  ),
                  child: MenuDrawerTopInfo(
                    onClosed: onClosed,
                  ),
                ),
                const Gap(height: 20),
                MenuDrawerTileList(onClosed: onClosed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
