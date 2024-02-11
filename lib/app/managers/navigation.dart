import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/build_context.dart';
import '../../core/extensions/color.dart';
import '../../core/extensions/string.dart';
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

  /// Shows a message to the user.
  ///
  /// * [text]: The message to show.
  /// * [type]: The type of message to show.
  /// * [showAction]: Whether to show an action button.
  /// * [showClose]: Whether to show a close button.
  /// * [maxLines]: The maximum number of lines to show.
  /// * [duration]: The duration of the message.
  /// * [dismissDirection]: The direction to dismiss the message.
  /// * [actionText]: The text of the action button.
  /// * [onAction]: The action to take when the action button is pressed.
  showMessage(
    String text, {
    MessageType type = MessageType.byDefault,
    bool showAction = false,
    bool showClose = true,
    int maxLines = 5,
    Duration duration = const Duration(seconds: 5),
    DismissDirection dismissDirection = DismissDirection.down,
    String? actionText,
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
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        content: Padding(
          padding: const EdgeInsets.all(4),
          child: TextCustom(
            text,
            maxLines: maxLines,
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
                label: actionText ?? LocaleKeys.common_close.tr(),
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

  /// Shows a dialog with buttons.
  ///
  /// * [title]: The title of the dialog.
  /// * [subtitle]: The optional subtitle of the dialog.
  /// * [acceptText]: The optional text of the accept button.
  /// * [cancelText]: The optional text of the cancel button.
  /// * [showAccept]: Whether to show the accept button.
  /// * [showCancel]: Whether to show the cancel button.
  /// * [showIcon]: Whether to show an icon.
  /// * [dissmisable]: Whether the dialog is dismissable.
  /// * [icon]: The icon asset path.
  /// * [iconData]: The icon data.
  /// * [onAccept]: The function to call when the accept button is pressed.
  /// * [onCancel]: The function to call when the cancel button is pressed.
  showDialogWithButton({
    required String title,
    String? subtitle,
    String? acceptText,
    String? cancelText,
    bool showAccept = true,
    bool showCancel = true,
    bool showIcon = true,
    bool dissmisable = true,
    String? icon,
    IconData? iconData,
    VoidCallback? onAccept,
    VoidCallback? onCancel,
  }) {
    showGeneralDialog(
      context: currentContext!,
      barrierDismissible: dissmisable,
      barrierLabel: '',
      transitionDuration: Durations.medium1,
      pageBuilder: (context, animation, _) => const SizedBox(),
      transitionBuilder: (context, animation, _, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.75, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1.0).animate(animation),
            child: AlertDialog(
              surfaceTintColor: context.theme.cardColor,
              backgroundColor: context.theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              icon: showIcon
                  ? CircleAvatar(
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
                    )
                  : null,
              title: Center(
                child: TextCustom(
                  title,
                  textAlign: TextAlign.center,
                  style: navigationKey.currentContext?.textStyle.bodyL.bold.bw,
                ),
              ),
              content: subtitle.isNotNullOrEmpty
                  ? TextCustom(
                      subtitle ?? '',
                      textAlign: TextAlign.center,
                      style: navigationKey.currentContext?.textStyle.bodyS.grey,
                    )
                  : null,
              actionsOverflowButtonSpacing: 15.h,
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: showAccept || showCancel
                  ? [
                      if (showAccept)
                        PushableButton(
                          onPressed: () {
                            onAccept?.call();
                            context.pop();
                          },
                          text: acceptText ?? LocaleKeys.common_okay.tr(),
                          type: PushableButtonType.primary,
                        ),
                      if (showCancel)
                        PushableButton(
                          onPressed: () {
                            onCancel?.call();
                            context.pop();
                          },
                          text: cancelText ?? LocaleKeys.common_cancel.tr(),
                          type: PushableButtonType.grey,
                        ),
                    ]
                  : null,
            ),
          ),
        );
      },
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
          backgroundColor: context.theme.cardColor,
          surfaceTintColor: context.theme.canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: context.theme.cardColor,
            ),
            child: Row(
              children: [
                CircularProgressIndicator(
                  color: context.colors.blue,
                ),
                const Gap(width: 30),
                const TextCustom("Please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
