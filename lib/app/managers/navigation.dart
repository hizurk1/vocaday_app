import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/build_context.dart';
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

  showMessage(String text, {MessageType type = MessageType.byDefault}) {
    ScaffoldMessenger.of(navigationKey.currentContext!).showSnackBar(
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
            color: Colors.white,
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
    bool oneButton = false,
    bool isShowIcon = true,
    String? icon,
    IconData? iconData,
  }) {
    showDialog(
      context: navigationKey.currentContext!,
      barrierDismissible: true,
      builder: (context) => Dialog(
        elevation: 1,
        backgroundColor:
            navigationKey.currentContext!.theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: navigationKey.currentContext!.screenWidth / 1.4,
          height: navigationKey.currentContext!.screenHeight / 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(12, 26),
                    blurRadius: 50,
                    spreadRadius: 0,
                    color: Colors.grey.withOpacity(.1)),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isShowIcon) ...[
                CircleAvatar(
                  backgroundColor:
                      navigationKey.currentContext!.theme.primaryColor,
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
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color:
                    navigationKey.currentContext!.textTheme.bodyMedium?.color,
              ),
              if (subtitle != null) ...[
                const Gap(height: 10),
                TextCustom(
                  subtitle,
                  fontWeight: FontWeight.w300,
                  color: navigationKey.currentContext!.theme.dividerColor
                      .withOpacity(.4),
                ),
              ],
              const Gap(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PushableButton(
                    onPressed: () {},
                    height: 45,
                    width: 90,
                    text: acceptText ?? 'Okay',
                  ),
                  if (!oneButton)
                    PushableButton(
                      onPressed: () {},
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
        context: navigationKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  showPleaseWaitDialog() {
    showDialog(
      context: navigationKey.currentContext!,
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
