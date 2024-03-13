import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/gen/assets.gen.dart';
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
            Assets.images.loginBackground,
            fit: BoxFit.fitHeight,
            height: context.screenHeight,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              width: context.screenWidth,
              height: context.screenHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.colors.black
                        .withOpacity(context.isDarkTheme ? 0.9 : 0),
                    context.colors.black
                        .withOpacity(context.isDarkTheme ? 0.9 : 0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
