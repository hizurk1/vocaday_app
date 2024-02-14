import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../../core/extensions/string.dart';
import '../constants/app_asset.dart';
import '../managers/navigation.dart';
import 'fullscreen_image.dart';

class CachedNetworkImageCustom extends StatelessWidget {
  const CachedNetworkImageCustom({
    super.key,
    required this.url,
    this.allowOpenFullscreenImage = true,
    this.size,
    this.radius,
    this.padding,
    this.color,
  });

  final String? url;
  final double? size;
  final double? radius;
  final double? padding;
  final Color? color;
  final bool allowOpenFullscreenImage;

  void _onTap() {
    if (allowOpenFullscreenImage) {
      Navigators().push(FullScreenImagePage(url: url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = this.radius ?? (size != null ? size! ~/ 2 : 1000);
    final child = url.isNullOrEmpty
        ? _defaultAvatar(size)
        : CachedNetworkImage(
            imageUrl: url!,
            placeholder: (context, url) => Container(
              height: size?.h,
              width: size?.w,
              color: context.backgroundColor,
            ),
            errorWidget: (context, url, error) => _defaultAvatar(size),
            errorListener: (value) => debugPrint('CachedNetworkImage: $value'),
            height: size?.h,
            width: size?.w,
            fit: BoxFit.cover,
          );

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((this.radius ?? radius).r),
          border: Border.all(color: color ?? context.greyColor.withOpacity(.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular((this.radius ?? radius).r),
          child: child,
        ),
      ),
    );
  }

  Widget _defaultAvatar(double? size) {
    final file = File(url ?? '');
    debugPrint('file: $file');
    return file.path.isNotEmpty
        ? Image.file(
            file,
            width: size?.w,
            height: size?.h,
            fit: BoxFit.cover,
          )
        : Image.asset(
            AppAssets.defaultAvatar,
            height: size?.h,
            width: size?.w,
            fit: BoxFit.cover,
          );
  }
}
