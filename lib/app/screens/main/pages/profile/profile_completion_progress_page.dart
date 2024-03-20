import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../features/user/user_profile/presentation/widgets/known_word/profile_completion_progress_knowns_chart_widget.dart';
import '../../../../widgets/gap.dart';

class ProfileCompletionProgressPage extends StatelessWidget {
  const ProfileCompletionProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
      child: const Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        children: [
          Gap(height: 40),
          ProfileCompletionProgressKnownsChartWidget(),
        ],
      ),
    );
  }
}
