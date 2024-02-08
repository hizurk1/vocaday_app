import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../constants/app_element.dart';

class SliverTabView extends StatelessWidget {
  /// topChild: the widget that should be filled on top of [tabBar] (optional)
  ///
  /// tabBar: required [TabBarCustom] class
  ///
  /// tabBarView: required [TabBarView] class
  const SliverTabView({
    super.key,
    this.topChild,
    required this.tabBar,
    required this.tabBarView,
    this.isPinned = true,
    this.onRefresh,
  });

  final Future<void> Function()? onRefresh;
  final Widget? topChild;
  final Widget tabBar;
  final TabBarView tabBarView;
  final bool isPinned;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: CustomScrollView(
        slivers: [
          if (topChild != null) SliverToBoxAdapter(child: topChild),
          //? Tab Bar
          SliverAppBar(
            floating: true,
            pinned: isPinned,
            toolbarHeight: AppElement.appBarSize + 20.h,
            backgroundColor: context.backgroundColor,
            surfaceTintColor: context.backgroundColor,
            flexibleSpace: Center(child: tabBar),
          ),
          //? Content view
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppElement.navBarSafeSize,
              ),
              child: tabBarView,
            ),
          ),
        ],
      ),
    );
  }
}
