import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/app_asset.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/text.dart';
import '../../domain/entities/word_entity.dart';

class SearchWordTileWidget extends StatelessWidget {
  const SearchWordTileWidget({
    super.key,
    required this.word,
  });

  final WordEntity word;

  void _onCopyToClipboard() {
    Clipboard.setData(ClipboardData(text: word.word.toLowerCase())).then((_) {
      Navigators().showMessage(LocaleKeys.common_is_copied_to_clipboard.tr(
        namedArgs: {'word': word.word.toLowerCase()},
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onLongPress: _onCopyToClipboard,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.theme.dividerColor.withOpacity(.2),
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: ListTile(
            title: TextCustom(
              word.word.toLowerCase(),
            ),
            subtitle: TextCustom(
              word.meanings.first.type.toLowerCase(),
              style: context.textStyle.caption.grey,
            ),
            trailing: GestureDetector(
              onTap: _onCopyToClipboard,
              child: SvgPicture.asset(
                AppAssets.copyIcon,
                width: 25.w,
                height: 25.h,
                colorFilter: ColorFilter.mode(
                  context.colors.grey300,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
