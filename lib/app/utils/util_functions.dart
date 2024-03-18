import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../managers/navigation.dart';
import '../translations/translations.dart';

/// A utility class containing various utility functions.
class UtilFunction {
  /// Constructs a new instance of [UtilFunction].
  ///
  /// This constructor is private to prevent direct instantiation of the class.
  /// Instead, use the [UtilFunction.splitFirst] method to access the instance.
  UtilFunction._();

  /// Splits the given [text] by the first occurrence of the [pattern] and returns
  /// the first element of the list.
  ///
  /// If [text] is null, this method returns an empty string.
  ///
  /// Example:
  ///
  /// ```dart
  /// String? text = 'hello+world';
  /// String pattern = '+';
  /// String result = UtilFunction.splitFirst(text, pattern);
  /// print(result); // Output: hello
  /// ```
  static String splitFirst(String? text, String pattern) =>
      text?.split(pattern).first ?? '';

  /// Splits the given [text] by the last occurrence of the [pattern] and returns
  /// the last element of the list.
  ///
  /// If [text] is null, this method returns an empty string.
  ///
  /// Example:
  ///
  /// ```dart
  /// String? text = 'hello/world';
  /// String pattern = '/';
  /// String result = UtilFunction.splitLast(text, pattern);
  /// print(result); // Output: world
  /// ```
  static String splitLast(String? text, String pattern) =>
      text?.split(pattern).last ?? '';

  /// Copy `text` to clipboard.
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      Navigators().showMessage(LocaleKeys.common_is_copied_to_clipboard.tr(
        namedArgs: {'word': text},
      ));
    });
  }

  /// Unfocus text field on the screen.
  static void unFocusTextField() =>
      FocusManager.instance.primaryFocus?.unfocus();

  /// Launch url
  static Future<void> launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await launcher.canLaunchUrl(uri)) {
        if (!await launcher.launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      }
    } catch (e) {
      Navigators().showMessage(e.toString(), type: MessageType.error);
    }
  }
}
