import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/constants/app_asset.dart';
import '../../../../app/constants/app_element.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/gap.dart';
import '../../../../app/widgets/loading_indicator.dart';
import '../../../../app/widgets/text.dart';
import '../blocs/search_word/search_word_bloc.dart';
import 'search_word_tile.dart';

class SearchBodyWidget extends StatelessWidget {
  const SearchBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchWordBloc, SearchWordState>(
      listener: (context, state) {
        if (state is SearchWordErrorState) {
          Navigators().showMessage(state.message, type: MessageType.error);
        }
      },
      builder: (context, state) {
        if (state is SearchWordEmptyState) {
          return _buildEmptySearch(
              LocaleKeys.search_type_something.tr(), context);
        }
        if (state is SearchWordLoadingState) {
          return const Center(child: LoadingIndicatorWidget());
        }
        if (state is SearchWordLoadedState) {
          if (state.exactWords.isNotEmpty || state.similarWords.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...state.exactWords
                      .map((word) => SearchWordTileWidget(word: word)),
                  if (state.similarWords.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: TextCustom(
                        LocaleKeys.search_are_you_looking_for.tr(),
                        style: context.textStyle.bodyS.grey,
                      ),
                    ),
                    ...state.similarWords
                        .map((word) => SearchWordTileWidget(word: word))
                  ],
                  Gap(height: AppElement.navBarSafeSize.h),
                ],
              ),
            );
          } else {
            return _buildEmptySearch(LocaleKeys.search_not_found.tr(), context);
          }
        }
        return Container();
      },
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
