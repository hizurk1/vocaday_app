import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../constants/app_asset.dart';
import '../../../routes/route_manager.dart';
import '../../../themes/app_color.dart';
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

  void _onSelectedTile(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        widget.onClosed();
        break;
      case 1:
        context.push(AppRoutes.setting);
        break;
      case 2:
      case 3:
        context.read<AuthBloc>().add(RequestSignOutEvent());
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
        ...[
          (AppAssets.homeIconOutline, LocaleKeys.page_home.tr()),
          (AppAssets.setting, LocaleKeys.page_setting.tr()),
          (null),
          (AppAssets.signOut, LocaleKeys.auth_sign_out.tr()),
        ].mapIndexed(
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
          color: context.colors.green200.withOpacity(0.25),
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
            color: context.colors.white,
          ),
        )
      ],
    );
  }
}
