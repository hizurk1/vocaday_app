import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/constants/app_asset.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/gap.dart';
import '../../../../app/widgets/loading_indicator.dart';
import '../../../../app/widgets/text.dart';
import '../../../../core/extensions/build_context.dart';
import '../blocs/search_word/search_word_bloc.dart';
import 'search_word_tile.dart';

class SearchBodyWidget extends StatelessWidget {
  const SearchBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchWordBloc, SearchWordState>(
      builder: (context, state) {
        if (state is SearchWordEmptyState) {
          return _buildEmptySearch(
              LocaleKeys.search_type_something.tr(), context);
        }
        if (state is SearchWordLoadingState) {
          return const Center(child: LoadingIndicatorWidget());
        }
        if (state is SearchWordErrorState) {
          return Center(child: TextCustom(state.message));
        }
        if (state is SearchWordLoadedState) {
          if (state.exactWords.isNotEmpty || state.similarWords.isNotEmpty) {
            final list = state.exactWords + state.similarWords;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                if (state.similarWords.isNotEmpty &&
                    index == state.exactWords.length - 1) {
                  return _buildSeparateText(state, context);
                }
                return SearchWordTileWidget(word: list[index]);
              },
            );
          } else {
            return _buildEmptySearch(LocaleKeys.search_not_found.tr(), context);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSeparateText(
    SearchWordLoadedState state,
    BuildContext context,
  ) {
    return Container(
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: state.exactWords.isNotEmpty
            ? context.colors.grey500.withOpacity(.08)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: context.colors.grey500.withOpacity(.1),
            width: 1,
          ),
        ),
      ),
      child: TextCustom(
        LocaleKeys.search_are_you_looking_for.tr(),
        style: context.textStyle.bodyS.grey,
      ),
    );
  }

  Widget _buildEmptySearch(String text, BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppAssets.notFound,
            width: 180.w,
            height: 180.h,
          ),
          Gap(height: 5.h),
          TextCustom(
            text,
            style: context.textStyle.bodyS.grey,
          ),
        ],
      ),
    );
  }
}
