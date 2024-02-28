import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../../features/word/presentation/blocs/search_word/search_word_bloc.dart';
import '../../../../../features/word/presentation/widgets/main_search/search_body.dart';
import '../../../../../features/word/presentation/widgets/main_search/search_top_app_bar.dart';
import '../../../../../injection_container.dart';
import '../../../../widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => sl<SearchWordBloc>(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBarCustom(
          enableShadow: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: const SearchTopAppBar(),
            ),
          ),
        ),
        body: SearchBodyWidget(),
      ),
    );
  }
}
