import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/build_context.dart';
import '../../core/extensions/color.dart';
import '../themes/app_color.dart';
import '../themes/app_text_theme.dart';
import '../translations/translations.dart';
import '../widgets/gap.dart';
import '../widgets/pushable_button.dart';
import '../widgets/text.dart';

enum MessageType { byDefault, info, success, error }

class Navigators {
  late GlobalKey<NavigatorState> navigationKey;

  static final Navigators _instance = Navigators._init();
  factory Navigators() => _instance;

  Navigators._init() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  BuildContext? get currentContext => navigationKey.currentContext;

  showMessage(
    String text, {
    MessageType type = MessageType.byDefault,
    bool showAction = false,
    bool showClose = false,
    Duration duration = const Duration(seconds: 5),
    DismissDirection dismissDirection = DismissDirection.down,
    VoidCallback? onAction,
  }) {
    final msgColor = switch (type) {
      MessageType.byDefault =>
        currentContext!.isDarkTheme ? AppColor().grey400 : AppColor().grey900,
      MessageType.info => AppColor().blue400,
      MessageType.success => AppColor().green400,
      MessageType.error => AppColor().red400,
    };
    final textColor = type == MessageType.byDefault
        ? AppColor().white
        : currentContext!.isDarkTheme
            ? msgColor.lighten(.25)
            : msgColor.darken(.35);
    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: msgColor.withOpacity(0.75),
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        content: Padding(
          padding: const EdgeInsets.all(4),
          child: TextCustom(
            text,
            style: navigationKey.currentContext?.textStyle.bodyS.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        showCloseIcon: showClose,
        closeIconColor: textColor,
        duration: duration,
        dismissDirection: dismissDirection,
        action: showAction
            ? SnackBarAction(
                label: LocaleKeys.common_close.tr(),
                textColor: textColor,
                onPressed: () {
                  onAction?.call();
                  ScaffoldMessenger.of(currentContext!).hideCurrentSnackBar(
                      reason: SnackBarClosedReason.dismiss);
                },
              )
            : null,
      ),
    );
  }

  showDialogWithButton({
    required String title,
    String? subtitle,
    String? acceptText,
    String? cancelText,
    bool isHideAccept = false,
    bool isHideCancel = false,
    bool isShowIcon = true,
    bool dissmisable = true,
    String? icon,
    IconData? iconData,
    VoidCallback? onAccept,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: currentContext!,
      barrierDismissible: dissmisable,
      builder: (context) => Dialog(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: context.theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: currentContext!.colors.grey600.withOpacity(.5),
                offset: const Offset(1, 1),
                blurRadius: 4,
                spreadRadius: 3,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isShowIcon) ...[
                CircleAvatar(
                  backgroundColor: context.theme.primaryColor,
                  radius: 25,
                  child: icon != null
                      ? SvgPicture.asset(
                          icon,
                          colorFilter: ColorFilter.mode(
                            currentContext!.colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      : Icon(
                          iconData ?? Icons.info,
                          color: currentContext!.colors.white,
                        ),
                ),
                const Gap(height: 25),
              ],
              TextCustom(
                title,
                style: navigationKey.currentContext?.textStyle.bodyL.bold.bw,
              ),
              if (subtitle != null) ...[
                const Gap(height: 10),
                TextCustom(
                  subtitle,
                  style: navigationKey.currentContext?.textStyle.bodyS.grey,
                ),
              ],
              const Gap(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!isHideAccept)
                    PushableButton(
                      onPressed: () {
                        onAccept?.call();
                        context.pop();
                      },
                      height: 45.w,
                      width: 90.h,
                      text: acceptText ?? LocaleKeys.common_okay.tr(),
                    ),
                  if (!isHideCancel)
                    PushableButton(
                      onPressed: () {
                        onCancel?.call();
                        context.pop();
                      },
                      height: 45.h,
                      width: 90.w,
                      text: cancelText ?? LocaleKeys.common_cancel.tr(),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showDefaultLoader() {
    Future.delayed(
      Duration.zero,
      () => showDialog(
        context: currentContext!,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  showPleaseWaitDialog() {
    showDialog(
      context: currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(30),
            child: const Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.blue,
                ),
                Gap(width: 20),
                TextCustom("Please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
