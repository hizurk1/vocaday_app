import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/word/presentation/blocs/search_word/search_word_bloc.dart';
import '../../../../../features/word/presentation/widgets/search_body.dart';
import '../../../../../features/word/presentation/widgets/search_top_app_bar.dart';
import '../../../../../injection_container.dart';
import '../../../../widgets/app_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchWordBloc>(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBarCustom(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const SearchTopAppBar(),
            ),
          ),
        ),
        body: SearchBodyWidget(),
      ),
    );
  }
}
