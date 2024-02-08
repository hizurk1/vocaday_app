import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../features/word/presentation/widgets/search_body.dart';
import '../../../../../../features/word/presentation/widgets/search_top_app_bar.dart';
import '../../../../../widgets/app_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: const SearchTopAppBar(),
          ),
        ),
      ),
      body: const SearchBodyWidget(),
    );
  }
}
