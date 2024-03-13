import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../constants/app_element.dart';
import 'tab_bar_custom.dart';

class SliverTabView extends StatelessWidget {
  /// topChild: the widget that should be filled on top of [tabBar] (optional)
  ///
  /// tabBar: required [TabBarCustom] class
  ///
  /// tabBarView: required [TabBarView] class
  const SliverTabView({
    super.key,
    this.topChild,
    required this.numberOfTabs,
    required this.tabs,
    required this.tabBarView,
    this.isPinned = true,
    this.physics,
    this.onRefresh,
    this.padding,
  });

  /// Trigger when users pull down to refresh the content data.
  final Future<void> Function()? onRefresh;

  /// The widget that places above tabBar.
  final Widget? topChild;

  /// Tabs for [TabBarCustom], `List<Tab>`
  final List<Tab> tabs;

  /// required [TabBarView] class
  final Widget tabBarView;

  /// Allow the [tabBar] is pinned on top or not.
  final bool isPinned;

  /// The total number of tabs.
  ///
  /// Typically greater than 1.
  /// Must match [tabBar]'s and [tabBarView.children]'s length.
  final int numberOfTabs;

  /// Horizontal & vertical padding for the whole screen, except tabBarView.
  final double? padding;

  /// Creates custom scroll effects using slivers.
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: numberOfTabs,
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: CustomScrollView(
          physics: physics,
          slivers: [
            if (topChild != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: padding ?? 0,
                    left: padding ?? 0,
                    top: padding ?? 0,
                  ).dm,
                  child: topChild,
                ),
              ),
            //? Tab Bar
            SliverAppBar(
              floating: true,
              pinned: isPinned,
              toolbarHeight: AppElement.appBarHeight.h + (padding ?? 20).h,
              backgroundColor: context.backgroundColor,
              surfaceTintColor: context.backgroundColor,
              flexibleSpace: Center(
                child: TabBarCustom(
                  horizontalMargin: padding,
                  tabs: tabs,
                ),
              ),
            ),
            //? Content view
            SliverFillRemaining(
              child: tabBarView,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: context.screenWidth,
                height: AppElement.navBarSafeSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
