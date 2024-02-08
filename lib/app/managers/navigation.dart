import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/build_context.dart';
import '../themes/app_text_theme.dart';
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

  showMessage(String text, {MessageType type = MessageType.byDefault}) {
    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: switch (type) {
          MessageType.byDefault => Colors.black.withOpacity(0.65),
          MessageType.info => Colors.blueAccent.withOpacity(0.65),
          MessageType.success => Colors.green.withOpacity(0.65),
          MessageType.error => Colors.redAccent.withOpacity(0.65),
        },
        content: Padding(
          padding: const EdgeInsets.all(4),
          child: TextCustom(
            text,
            style: navigationKey.currentContext?.textStyle.bodyS.white,
          ),
        ),
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
        elevation: 1,
        backgroundColor: context.theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: context.screenWidth / 1.4,
          height: context.screenHeight / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
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
                      ? SvgPicture.asset(icon)
                      : iconData != null
                          ? Icon(iconData)
                          : const Icon(Icons.info),
                ),
                const Gap(height: 25),
              ],
              TextCustom(
                title,
                style: navigationKey.currentContext?.textStyle.bodyL.bw,
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
                      height: 45,
                      width: 90,
                      text: acceptText ?? 'Okay',
                    ),
                  if (!isHideCancel)
                    PushableButton(
                      onPressed: () {
                        onCancel?.call();
                        context.pop();
                      },
                      height: 45,
                      width: 90,
                      text: cancelText ?? 'Cancel',
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
