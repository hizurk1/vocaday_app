import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/app_logger.dart';
import '../../../core/extensions/build_context.dart';
import '../../themes/app_text_theme.dart';
import '../../translations/translations.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list_tile_custom.dart';
import '../../widgets/text.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBarCustom(
        leading: const BackButton(),
        textTitle: LocaleKeys.page_setting.tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              color: context.greyColor.withOpacity(.15),
              child: TextCustom(
                "Preferences",
                style: context.textStyle.caption.grey,
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  logger.i("tap");
                },
                child: ListTileCustom(
                  width: context.screenWidth,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  leading: const Icon(Icons.language),
                  titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
                  title: TextCustom(
                    "Languages",
                    style: context.textStyle.bodyS.bw,
                  ),
                  trailing: DropdownButton(
                    underline: const SizedBox(),
                    value: context.locale,
                    onChanged: (Locale? value) {
                      //
                    },
                    elevation: 1,
                    items: [
                      DropdownMenuItem(
                        value: AppLocale.en.instance,
                        child: TextCustom(
                          LocaleKeys.app_language_english.tr(),
                          style: context.textStyle.caption.bw,
                        ),
                      ),
                      DropdownMenuItem(
                        value: AppLocale.vi.instance,
                        child: TextCustom(
                          LocaleKeys.app_language_vietnamese.tr(),
                          style: context.textStyle.caption.bw,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
