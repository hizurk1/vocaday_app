import 'package:flutter/material.dart';

import '../../../../../../app/themes/app_color.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/widgets.dart';

class KnownWordButtonWidget extends StatelessWidget {
  const KnownWordButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final bool isLoading;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return PushableButton(
      onPressed: onPressed,
      text: LocaleKeys.activity_i_knew.tr(),
      child: isLoading
          ? LoadingIndicatorWidget(
              color: context.colors.white,
            )
          : null,
    );
  }
}
