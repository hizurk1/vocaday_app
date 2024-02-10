import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A widget that takes up space with the given dimensions.
///
/// The Gap widget is useful for creating gaps between other widgets,
/// or for aligning them in a grid layout.
///
/// The Gap widget takes two optional parameters: `height` and `width`.
/// If either parameter is specified, the gap will be the specified size
/// in logical pixels. If both are omitted, the gap will be the size of
/// the default icon font.
///
/// The Gap widget uses the [MediaQuery] to determine the size of the gap
/// in physical pixels, taking into account the device's display density.
///
/// The Gap widget is intended to be used with the [Row] and [Column]
/// widgets, which provide alignment and wrapping behavior. For example:
///
/// ```dart
/// Row(
///   children: [
///     Icon(Icons.ac_unit),
///     Gap(width: 16.0),
///     Icon(Icons.airplanemode_active),
///   ],
/// )
/// ```
class Gap extends StatelessWidget {
  /// Creates a gap with the given dimensions.
  const Gap({
    this.height,
    this.width,
    super.key,
  });

  /// The height of the gap, in logical pixels.
  final double? height;

  /// The width of the gap, in logical pixels.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height?.h,
      width: width?.w,
    );
  }
}
