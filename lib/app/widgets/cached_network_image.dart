import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_asset.dart';

class CachedNetworkImageCustom extends StatelessWidget {
  const CachedNetworkImageCustom({
    super.key,
    required this.url,
    required this.size,
  });

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: url.isEmpty
          ? Image.asset(
              AppAssets.defaultAvatar,
              height: size.h,
              width: size.w,
            )
          : CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Placeholder(
                fallbackHeight: size.h,
                fallbackWidth: size.w,
              ),
              errorWidget: (context, url, error) => Image.asset(
                AppAssets.defaultAvatar,
                height: size.h,
                width: size.w,
              ),
              width: size.w,
              height: size.h,
              fit: BoxFit.cover,
            ),
    );
  }
}
