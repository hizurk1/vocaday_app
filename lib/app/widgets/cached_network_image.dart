import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_logger.dart';
import '../../core/extensions/build_context.dart';
import '../../core/extensions/string.dart';
import '../constants/gen/assets.gen.dart';
import '../managers/navigation.dart';
import 'fullscreen_image.dart';

class CachedNetworkImageCustom extends StatelessWidget {
  const CachedNetworkImageCustom({
    super.key,
    required this.url,
    this.allowOpenFullscreenImage = true,
    this.isAvatar = true,
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
  final bool isAvatar;

  void _onTap() {
    if (allowOpenFullscreenImage) {
      Navigators().push(FullScreenImagePage(url: url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = isAvatar ? _buildAvatarImage() : _buildNormalImage();

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((radius ?? 1000).r),
          border: Border.all(color: color ?? context.greyColor.withOpacity(.3)),
        ),
        child: radius != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular((radius ?? 1000).r),
                child: child,
              )
            : ClipOval(child: child),
      ),
    );
  }

  Widget _buildNormalImage() {
    final child = url.isNullOrEmpty
        ? Container()
        : CachedNetworkImage(
            imageUrl: url!,
            placeholder: (context, url) => Container(
              color: context.backgroundColor,
            ),
            errorWidget: (context, url, error) => Container(),
            errorListener: (error) => logger.e(
              'CachedNetworkImageCustom._buildNormalImage',
              error: error,
            ),
            fit: BoxFit.cover,
          );
    return child;
  }

  Widget _buildAvatarImage() {
    final child = url.isNullOrEmpty
        ? _defaultAvatar(size)
        : CachedNetworkImage(
            imageUrl: url!,
            placeholder: (context, url) => Container(
              height: size?.r,
              width: size?.r,
              color: context.backgroundColor,
            ),
            errorWidget: (context, url, error) => _defaultAvatar(size),
            errorListener: (error) => logger.e(
              'CachedNetworkImageCustom._buildAvatarImage',
              error: error,
            ),
            height: size?.r,
            width: size?.r,
            fit: BoxFit.cover,
          );
    return child;
  }

  Widget _defaultAvatar(double? size) {
    final file = File(url ?? '');
    return file.path.isNotEmpty
        ? Image.file(
            file,
            width: size?.r,
            height: size?.r,
            fit: BoxFit.cover,
          )
        : Image.asset(
            Assets.images.defaultAvatar.path,
            height: size?.r,
            width: size?.r,
            fit: BoxFit.cover,
          );
  }
}
