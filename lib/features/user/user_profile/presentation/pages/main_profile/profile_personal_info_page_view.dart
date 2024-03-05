import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../../app/screens/main/pages/profile/widgets/profile_info_item.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/error_page.dart';
import '../../../../../../app/widgets/loading_indicator.dart';
import '../../../../../../core/extensions/date_time.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class ProfilePersonalInfoPage extends StatelessWidget {
  const ProfilePersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoadingState) {
          return const LoadingIndicatorPage();
        }
        if (state is UserDataErrorState) {
          return ErrorPage(text: state.message);
        }
        if (state is UserDataLoadedState) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 30.w),
            child: Wrap(
              children: [
                ProfileInfoItemWidget(
                  icon: Assets.icons.email,
                  title: "Email",
                  content: state.entity.email,
                ),
                ProfileInfoItemWidget(
                  icon: Assets.icons.phone,
                  title: LocaleKeys.profile_phone.tr(),
                  content: state.entity.phone ?? '',
                ),
                ProfileInfoItemWidget(
                  icon: Assets.icons.birthday,
                  title: LocaleKeys.profile_birthday.tr(),
                  content: state.entity.birthday?.ddMMyyyy ?? '',
                ),
                ProfileInfoItemWidget(
                  icon: Assets.icons.gender,
                  title: LocaleKeys.profile_gender.tr(),
                  content: state.entity.gender ?? '',
                ),
                ProfileInfoItemWidget(
                  icon: Assets.icons.attendance,
                  title: LocaleKeys.profile_attendance.tr(),
                  content: state.entity.attendance?.length.toString() ?? '',
                ),
                ProfileInfoItemWidget(
                  icon: Assets.icons.calendarOutline,
                  title: LocaleKeys.profile_created_date.tr(),
                  content: state.entity.createdDate?.ddMMyyyy ?? '',
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
