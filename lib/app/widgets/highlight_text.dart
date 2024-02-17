import 'package:flutter/material.dart';

import '../themes/app_text_theme.dart';

class HighlightText extends StatelessWidget {
  const HighlightText({
    super.key,
    required this.text,
    required this.highlight,
    required this.style,
    this.highlightStyle,
  });

  final String text;
  final String highlight;
  final TextStyle style;
  final TextStyle? highlightStyle;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> children = [];
    List<String> parts = text.split(highlight);

    for (int i = 0; i < parts.length; i++) {
      children.add(TextSpan(text: parts[i], style: style));

      if (i < parts.length - 1) {
        children.add(TextSpan(
          text: highlight,
          style: highlightStyle ?? style.bold,
        ));
      }
    }

    return SelectableText.rich(
      TextSpan(children: children),
    );
  }
}
