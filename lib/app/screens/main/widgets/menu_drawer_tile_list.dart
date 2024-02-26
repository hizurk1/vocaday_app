import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../constants/app_asset.dart';
import '../../../managers/navigation.dart';
import '../../../routes/route_manager.dart';
import '../../../themes/app_color.dart';
import '../../../themes/app_text_theme.dart';
import '../../../translations/translations.dart';
import '../../../widgets/text.dart';
import 'menu_drawer_tile.dart';

class MenuDrawerTileList extends StatefulWidget {
  const MenuDrawerTileList({super.key, required this.onClosed});

  final VoidCallback onClosed;

  @override
  State<MenuDrawerTileList> createState() => _MenuDrawerTileListState();
}

class _MenuDrawerTileListState extends State<MenuDrawerTileList> {
  int selectedIndex = 0;
  final List<(String icon, String title, String route)?> menuList = [
    (AppAssets.homeIconOutline, LocaleKeys.page_home.tr(), AppRoutes.home),
    (AppAssets.love, LocaleKeys.page_favourite.tr(), AppRoutes.favourite),
    (AppAssets.setting, LocaleKeys.page_setting.tr(), AppRoutes.setting),
    null,
    (AppAssets.signOut, LocaleKeys.auth_sign_out.tr(), ''),
  ];

  _resetIndex() {
    Future.delayed(Durations.medium2, () {
      if (mounted) setState(() => selectedIndex = 0);
    });
  }

  void _onSelectedTile(int index) async {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        widget.onClosed();
        break;
      case 1:
      case 2:
        _resetIndex();
        context.push(menuList[index]!.$3);
        break;
      case 3:
        final result = await Navigators().showDialogWithButton(
          title: LocaleKeys.auth_sign_out.tr(),
          subtitle: LocaleKeys.auth_are_you_want_to_sign_out.tr(),
          acceptText: LocaleKeys.auth_sign_out.tr(),
          onAccept: () {
            context.read<AuthBloc>().add(RequestSignOutEvent());
          },
        );
        if (result == null || !result) _resetIndex();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleUpperCase(LocaleKeys.common_browse.tr()),
        ...menuList.mapIndexed(
          (index, tile) {
            if (tile == null) {
              return _buildTitleUpperCase(LocaleKeys.common_other_k.tr());
            }
            return MenuDrawerTile(
              onTap: () => _onSelectedTile(index),
              index: index,
              selectedIndex: selectedIndex,
              icon: tile.$1,
              title: tile.$2,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDividerMenu() => Padding(
        padding: EdgeInsets.only(left: 5.w),
        child: Divider(
          color: context.colors.blue200.withOpacity(0.2),
          height: 1,
        ),
      );

  Widget _buildTitleUpperCase(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDividerMenu(),
        Container(
          padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 15.h),
          child: TextCustom(
            text.toUpperCase(),
            style: context.textStyle.bodyS.white,
          ),
        )
      ],
    );
  }
}
