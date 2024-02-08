import 'package:flutter/material.dart';

import '../themes/app_text_theme.dart';

class TextCustom extends StatelessWidget {
  /// Style by default is bodyS with bw
  const TextCustom(
    this.text, {
    this.maxLines = 2,
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
