import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../../core/extensions/string.dart';
import '../constants/app_asset.dart';

class CachedNetworkImageCustom extends StatelessWidget {
  const CachedNetworkImageCustom({
    super.key,
    required this.url,
    required this.size,
    this.radius,
    this.padding,
    this.color,
  });

  final String? url;
  final double size;
  final double? radius;
  final double? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final child = url.isNullOrEmpty
        ? _defaultAvatar()
        : CachedNetworkImage(
            imageUrl: url!,
            placeholder: (context, url) => Placeholder(
              fallbackHeight: size.h,
              fallbackWidth: size.w,
            ),
            errorWidget: (context, url, error) => _defaultAvatar(),
            width: size.w,
            height: size.h,
            fit: BoxFit.cover,
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((radius ?? 180).r),
        border: Border.all(color: color ?? context.greyColor.withOpacity(.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular((radius ?? 180).r),
        child: child,
      ),
    );
  }

  Widget _defaultAvatar() {
    return Image.asset(
      AppAssets.defaultAvatar,
      height: size.h,
      width: size.w,
    );
  }
}
