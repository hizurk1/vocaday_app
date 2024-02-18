import 'package:flutter/material.dart';

import '../../core/extensions/string.dart';
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
    String indexText = text.substring(0, 3);
    children.add(TextSpan(text: indexText, style: style));

    String highLightText = highlight;
    String exIndexText = text.substring(3).uncapitalizeFirstLetter;

    List<String> parts = exIndexText.split(highLightText);

    if (parts[0] == '') {
      highLightText = highLightText.capitalizeFirstLetter;
    } else {
      parts[0] = parts[0].capitalizeFirstLetter;
    }

    for (int i = 0; i < parts.length; i++) {
      children.add(TextSpan(text: parts[i], style: style));

      if (i < parts.length - 1) {
        children.add(TextSpan(
          text: highLightText,
          style: highlightStyle ?? style.bold,
        ));
      }
    }

    return SelectableText.rich(
      TextSpan(children: children),
    );
  }
}
