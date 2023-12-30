import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/build_context.dart';

class TopTabBar extends StatelessWidget {
  const TopTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: TabBar(
        indicatorWeight: 4,
        labelPadding: EdgeInsets.only(bottom: 5.h),
        labelColor: context.textTheme.bodyLarge?.color,
        labelStyle: context.textTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: context.textTheme.bodyLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: context.textTheme.bodyLarge?.color?.withOpacity(.25),
        ),
        indicatorColor: context.textTheme.bodyLarge?.color,
        indicatorPadding: EdgeInsets.symmetric(
          horizontal: 5.w,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'Sign In'),
          Tab(text: 'Sign Up'),
        ],
      ),
    );
  }
}
