import 'package:flutter/material.dart';

import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/widgets.dart';

class KnownWordButtonWidget extends StatelessWidget {
  const KnownWordButtonWidget({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return PushableButton(
      onPressed: onPressed,
      text: LocaleKeys.activity_i_knew.tr(),
    );
  }
}
