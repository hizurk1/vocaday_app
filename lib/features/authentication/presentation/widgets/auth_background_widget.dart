import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/app_asset.dart';
import '../../../../app/themes/app_color.dart';

class AuthBackgroundWidget extends StatelessWidget {
  const AuthBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          SvgPicture.asset(
            AppAssets.loginBackground,
            fit: BoxFit.cover,
          ),
          Container(
            width: context.screenWidth,
            height: context.screenHeight,
            color: AppColor.black.withOpacity(
              context.isDarkTheme ? 0.85 : 0,
            ),
          ),
        ],
      ),
    );
  }
}
