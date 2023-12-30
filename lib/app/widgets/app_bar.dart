import 'package:flutter/material.dart';

import '../themes/app_color.dart';
import 'text.dart';

AppBar appBarCustom() {
  return AppBar(
    elevation: 2,
    shadowColor: AppColor.grey.withOpacity(.2),
    backgroundColor: AppColor.white,
    centerTitle: true,
    title: const TextCustom(
      'Object Detection',
      color: AppColor.primaryDark,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
