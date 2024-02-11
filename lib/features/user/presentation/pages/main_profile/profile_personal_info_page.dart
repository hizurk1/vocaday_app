import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/app_asset.dart';
import '../../../../../app/screens/main/pages/profile/widgets/profile_info_item.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/error_page.dart';
import '../../../../../app/widgets/loading_indicator.dart';
import '../../../../../core/extensions/date_time.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class ProfilePersonalInfoPage extends StatelessWidget {
  const ProfilePersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoadingState) {
          return const Center(child: LoadingIndicatorWidget());
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
                  icon: AppAssets.emailIcon,
                  title: "Email",
                  content: state.entity.email,
                ),
                ProfileInfoItemWidget(
                  icon: AppAssets.phoneOutline,
                  title: LocaleKeys.profile_phone.tr(),
                  content: state.entity.phone ?? '',
                ),
                ProfileInfoItemWidget(
                  icon: AppAssets.calendarOutline,
                  title: LocaleKeys.profile_birthday.tr(),
                  content: state.entity.birthday?.ddMMyyyy ?? '',
                ),
                ProfileInfoItemWidget(
                  icon: AppAssets.genderOutline,
                  title: LocaleKeys.profile_gender.tr(),
                  content: state.entity.gender ?? '',
                ),
                ProfileInfoItemWidget(
                  icon: AppAssets.calendarOutline,
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
