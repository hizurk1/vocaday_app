import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/constants/app_asset.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/error_page.dart';
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
          return ErrorPage(
            text: LocaleKeys.search_type_something.tr(),
            image: AppAssets.notFound,
          );
        }
        if (state is SearchWordLoadingState) {
          return const Center(child: LoadingIndicatorWidget());
        }
        if (state is SearchWordErrorState) {
          return ErrorPage(text: state.message);
        }
        if (state is SearchWordLoadedState) {
          if (state.exactWords.isNotEmpty || state.similarWords.isNotEmpty) {
            return ListView(
              children: [
                ...state.exactWords.map((e) => SearchWordTileWidget(word: e)),
                if (state.similarWords.isNotEmpty) ...[
                  _buildSeparateText(state, context),
                  ...state.similarWords
                      .map((e) => SearchWordTileWidget(word: e))
                ],
              ],
            );
          } else {
            return ErrorPage(
              text: LocaleKeys.search_not_found.tr(),
              image: AppAssets.notFoundDog,
            );
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
}
