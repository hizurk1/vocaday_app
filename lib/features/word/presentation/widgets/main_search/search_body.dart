import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../blocs/search_word/search_word_bloc.dart';
import 'search_word_tile.dart';

class SearchBodyWidget extends StatelessWidget {
  SearchBodyWidget({super.key});

  final exactLength = ValueNotifier<int>(10);
  final similarLength = ValueNotifier<int>(10);

  void _onLoadMore(ValueNotifier<int> notifier) {
    notifier.value += 10;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchWordBloc, SearchWordState>(
      builder: (context, state) {
        if (state is SearchWordEmptyState) {
          return ErrorPage(
            text: LocaleKeys.search_type_something.tr(),
            image: Assets.jsons.notFound,
          );
        }
        if (state is SearchWordLoadingState) {
          return const LoadingIndicatorPage();
        }
        if (state is SearchWordErrorState) {
          return ErrorPage(text: state.message);
        }
        if (state is SearchWordLoadedState) {
          exactLength.value = 10;
          similarLength.value = 10;

          if (state.exactWords.isNotEmpty || state.similarWords.isNotEmpty) {
            return ListView(
              children: [
                if (state.exactWords.isNotEmpty)
                  ValueListenableBuilder(
                    valueListenable: exactLength,
                    builder: (_, count, __) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...state.exactWords
                              .take(count)
                              .map((e) => SearchWordTileWidget(word: e)),
                          if (count < AppValueConst.maxItemLoad &&
                              count < state.exactWords.length)
                            _buildLoadMoreButton(
                              context: context,
                              notifier: exactLength,
                            ),
                        ],
                      );
                    },
                  ),
                if (state.similarWords.isNotEmpty)
                  ValueListenableBuilder(
                    valueListenable: similarLength,
                    builder: (_, count, __) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSeparateText(state, context),
                          ...state.similarWords
                              .take(count)
                              .map((e) => SearchWordTileWidget(word: e)),
                          if (count < AppValueConst.maxItemLoad &&
                              count < state.similarWords.length)
                            _buildLoadMoreButton(
                              context: context,
                              notifier: similarLength,
                            ),
                        ],
                      );
                    },
                  ),
              ],
            );
          } else {
            return ErrorPage(
              text: LocaleKeys.search_not_found.tr(),
              image: Assets.jsons.notFoundDog,
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildLoadMoreButton({
    required BuildContext context,
    required ValueNotifier<int> notifier,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onLoadMore(notifier),
        child: Container(
          width: context.screenWidth,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextCustom(
                  LocaleKeys.search_show_more.tr(),
                  style: context.textStyle.bodyS.grey,
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(
                  Assets.icons.arrowDown,
                  height: 12.h,
                  colorFilter: ColorFilter.mode(
                    context.colors.grey,
                    BlendMode.srcIn,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
          top: BorderSide(
            color: context.colors.grey500.withOpacity(.1),
            width: 1,
          ),
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
