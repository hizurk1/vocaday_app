import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/date_time.dart';
import '../../../injection_container.dart';
import '../../constants/gen/assets.gen.dart';
import '../../managers/language.dart';
import '../../managers/navigation.dart';
import '../../managers/shared_preferences.dart';
import '../../managers/theme.dart';
import '../../themes/app_text_theme.dart';
import '../../translations/translations.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list_tile_custom.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/text.dart';
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
          leading: const BackButton(),
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
