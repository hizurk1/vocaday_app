import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/color.dart';
import '../../constants/app_asset.dart';
import '../../themes/app_color.dart';
import 'pages/activity/pages/activity_page.dart';
import 'pages/home/pages/home_page.dart';
import 'pages/profile/pages/profile_page.dart';
import 'pages/search/pages/search_page.dart';
import 'widgets/menu_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int currentPage = 0;
  bool isMenuOpen = false;
  bool _isSwipeRight = false;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;
  late double menuSize;
  late double bottomNavSize;
  late List<(String iconFill, String iconOutline)> navIcons;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();

    navIcons = [
      (AppAssets.homeIconFill, AppAssets.homeIconOutline),
      (AppAssets.searchIconFill, AppAssets.searchIconOutline),
      (AppAssets.bookIconFill, AppAssets.bookIconOutline),
      (AppAssets.profileIconFill, AppAssets.profileIconOutline),
    ];

    pages = [
      const HomePage(),
      const SearchPage(),
      const ActivityPage(),
      const ProfilePage(),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSwipeScreen(DragUpdateDetails swiping) {
    if (!_isSwipeRight && !isMenuOpen) {
      if (swiping.delta.dx > 0) {
        _isSwipeRight = true;
        _animationController.forward();
        setState(() => isMenuOpen = true);
      }
    }
    if (_isSwipeRight && isMenuOpen) {
      if (swiping.delta.dx < 0) {
        _isSwipeRight = false;
        _animationController.reverse();
        setState(() => isMenuOpen = false);
      }
    }
  }

  void _onMenuDrawer() {
    if (isMenuOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      isMenuOpen = false;
      _isSwipeRight = false;
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    menuSize = context.screenWidth * 0.65;
    bottomNavSize = 52.h;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        debugPrint('rebuild-child');
        return PopScope(
          canPop: false,
          child: GestureDetector(
            onHorizontalDragUpdate: _onSwipeScreen,
            child: Scaffold(
              backgroundColor: context.colors.drawer.darken(
                context.isDarkTheme ? 0.05 : 0,
              ),
              body: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                    width: menuSize,
                    left: isMenuOpen ? 0 : -menuSize,
                    height: context.screenHeight,
                    child: MenuDrawer(
                      onClosed: _onMenuDrawer,
                    ),
                  ),
                  Transform(
                    transform: Matrix4.identity(),
                    child: Transform.translate(
                      offset: Offset(animation.value * menuSize, 0),
                      child: Transform.scale(
                        scale: scaleAnimation.value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            isMenuOpen ? 25.r : 0.0,
                          ),
                          child: pages[currentPage],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              extendBody: true,
              bottomNavigationBar: _buildBottomNavigationBar(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Transform.translate(
      offset: Offset(0, bottomNavSize * 1.5 * animation.value),
      child: SafeArea(
        child: Container(
          height: bottomNavSize,
          padding: EdgeInsets.symmetric(
            vertical: 10.h / 2,
            horizontal: 10.w * 1.25,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 12.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: context.theme.dialogBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: context.colors.cardDark.withOpacity(.05),
              )
            ],
            border: Border.all(
              color: context.theme.dividerColor
                  .withOpacity(context.isDarkTheme ? 0.5 : 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: navIcons
                .mapIndexed(
                  (index, icons) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => currentPage = index),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 50.h,
                        width: bottomNavSize,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          // color: currentPage == index
                          //     ? COLOR_LIGHT_PRIMARY.withOpacity(0.2)
                          //     : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          currentPage == index ? icons.$1 : icons.$2,
                          height: 25,
                          width: 25,
                          colorFilter: ColorFilter.mode(
                            currentPage == index
                                ? context.theme.primaryColor
                                : context.theme.dividerColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
