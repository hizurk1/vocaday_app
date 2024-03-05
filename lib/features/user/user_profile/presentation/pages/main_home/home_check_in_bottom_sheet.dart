import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../../app/managers/navigation.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/bottom_sheet/dynamic_bottom_sheet.dart';
import '../../../../../../app/widgets/pushable_button.dart';
import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/extensions/date_time.dart';
import '../../../../../../core/extensions/list.dart';
import '../../cubits/user_data/user_data_cubit.dart';

class HomeCheckInBottomSheet extends StatelessWidget {
  const HomeCheckInBottomSheet({super.key});

  Future<void> _onAttendancePressed({
    required String uid,
    required Map<DateTime, int> dataSets,
    required BuildContext context,
  }) async {
    dataSets[DateTime.now().resetTime] = 1;
    final List<DateTime> attendance = dataSets.keys.toList();

    Navigators().popDialog();
    await Navigators().showLoading(
      tasks: [context.read<UserDataCubit>().addAttendanceDate(uid, attendance)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        bool checkedIn = false;
        Map<DateTime, int> datasets = {};
        if (state is UserDataLoadedState) {
          if (state.entity.attendance.isNotNullOrEmpty) {
            state.entity.attendance?.toSet().forEach((date) {
              datasets[date.resetTime] = 1;
              if (!checkedIn) {
                checkedIn = date.eqvYearMonthDay(DateTime.now());
              }
            });
          }
          return DynamicBottomSheetCustom(
            showDragHandle: true,
            padding:
                EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 25.h),
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return HeatMapCalendar(
                    showColorTip: false,
                    datasets: datasets,
                    // flexible: true,
                    size: (constraints.maxWidth - 30.w) / 7 - 3.w,
                    defaultColor: context.greyColor.withOpacity(0.15),
                    textColor: context.textStyle.bodyS.bw.color,
                    monthFontSize: context.textStyle.bodyL.fontSize,
                    colorsets: {1: context.primaryLight},
                  );
                },
              ),
              if (!checkedIn)
                Container(
                  padding: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
                  child: PushableButton(
                    onPressed: () async {
                      if (!checkedIn) {
                        await _onAttendancePressed(
                          uid: state.entity.uid,
                          dataSets: datasets,
                          context: context,
                        );
                      }
                    },
                    type: PushableButtonType.primary,
                    text: LocaleKeys.home_check_in.tr(),
                  ),
                )
            ],
          );
        }
        return Container();
      },
    );
  }
}
