import 'package:flutter/material.dart';

import '../themes/app_text_theme.dart';

/// A custom text widget that provides a consistent look and feel throughout the app.
///
/// This widget can be used to display body text, headings, or other types of text. It
/// supports customizing the font size, color, and other properties. By default, it
/// uses the text style with body small and bw style.
///
/// ```dart
/// TextCustom(
///   'This is body text',
///   style: TextStyle(),
///   maxLines: 3,
///   textAlign: TextAlign.center,
/// )
/// ```
class TextCustom extends StatelessWidget {
  /// Creates a custom text widget.
  ///
  /// The [text] parameter is the text that will be displayed. The [style] parameter
  /// is the text style to use. The [maxLines] parameter is the maximum number of lines
  /// to display. The [textAlign] parameter is the alignment of the text.
  ///
  /// By default, it uses the text style with body small and bw style.
  const TextCustom(
    this.text, {
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.style,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style ?? context.textStyle.bodyS.bw,
      textAlign: textAlign,
    );
  }
}
