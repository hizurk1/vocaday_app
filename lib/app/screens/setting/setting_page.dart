import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/date_time.dart';
import '../../../features/authentication/presentation/widgets/setting_delete_account_bottom_sheet.dart';
import '../../../injection_container.dart';
import '../../constants/app_const.dart';
import '../../constants/gen/assets.gen.dart';
import '../../managers/language.dart';
import '../../managers/navigation.dart';
import '../../managers/shared_preferences.dart';
import '../../managers/theme.dart';
import '../../themes/app_text_theme.dart';
import '../../translations/translations.dart';
import '../../utils/util_functions.dart';
import '../../widgets/widgets.dart';
import 'cubits/schedule_notification/schedule_notification_cubit.dart';

part 'widgets/setting_about_us.dart';
part 'widgets/setting_check_for_update.dart';
part 'widgets/setting_delete_acc.dart';
part 'widgets/setting_language.dart';
part 'widgets/setting_notification.dart';
part 'widgets/setting_privacy_policy.dart';
part 'widgets/setting_rate_app.dart';
part 'widgets/setting_theme.dart';
part 'widgets/setting_title.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBarCustom(
          leading: BackButton(
            style: ButtonStyle(iconSize: MaterialStateProperty.all(24.r)),
          ),
          textTitle: LocaleKeys.page_setting.tr(),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _SettingTitle(LocaleKeys.setting_general.tr()),
              _SettingLanguage(),
              _SettingTheme(),
              _SettingNotification(),
              _SettingTitle(LocaleKeys.setting_others.tr()),
              _SettingRateApp(),
              _SettingCheckUpdate(),
              _SettingPrivacyPolicy(),
              _SettingAboutUs(),
              _SettingTitle(LocaleKeys.setting_danger_zone.tr()),
              _SettingDeleteAcc(),
            ],
          ),
        ),
      ),
    );
  }
}
