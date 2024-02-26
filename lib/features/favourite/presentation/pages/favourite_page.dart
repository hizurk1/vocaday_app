import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/constants/app_asset.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/managers/shared_preferences.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/app_bar.dart';
import '../../../../app/widgets/error_page.dart';
import '../../../../app/widgets/list_tile_custom.dart';
import '../../../../app/widgets/loading_indicator.dart';
import '../../../../app/widgets/text.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../injection_container.dart';
import '../../../word/domain/entities/word_entity.dart';
import '../../../word/domain/usecases/get_all_words.dart';
import '../../../word/presentation/pages/word_detail_bottom_sheet.dart';
import '../cubit/word_favourite_cubit.dart';
import '../widgets/search_favourite_word_widget.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final ValueNotifier<List<WordEntity>> favourteNotifer = ValueNotifier([]);

  Future<void> _onRefresh(
    BuildContext context, {
    Duration delay = Durations.long2,
  }) async {
    Navigators().showLoading(
      tasks: [
        context.read<WordFavouriteCubit>().getAllFavouriteWords(),
      ],
      delay: delay,
    );
  }

  void _onOpenWordDetail(BuildContext context, WordEntity entity) async {
    await context.showBottomSheet(
      child: WordDetailBottomSheet(wordEntity: entity),
    );
    if (mounted) await _onRefresh(context, delay: Duration.zero);
  }

  Future<void> _onSearch(BuildContext context, String input) async {
    if (input.isNotEmpty) {
      favourteNotifer.value = favourteNotifer.value
          .where((e) => e.word.toLowerCase().contains(input))
          .toList();
    } else {
      await context.read<WordFavouriteCubit>().getAllFavouriteWords();
    }
  }

  Future<void> _onRemoveItem(String word) async {
    await Navigators().showLoading(tasks: [
      sl<SharedPrefManager>().removeFavouriteWord(word),
    ], delay: Durations.medium2);
    favourteNotifer.value = List<WordEntity>.from(favourteNotifer.value)
      ..removeWhere((e) => e.word == word);
  }

  Future<void> _onClearAll(BuildContext context) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.favourite_clear_all_fav_title.tr(),
      subtitle: LocaleKeys.favourite_clear_all_favourites.tr(),
      acceptText: LocaleKeys.common_accept.tr(),
      onAccept: () async {
        sl<SharedPrefManager>().clearAllFavouriteWords();
        await context.read<WordFavouriteCubit>().getAllFavouriteWords();
        favourteNotifer.value = [];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WordFavouriteCubit(sl<GetAllWordsUsecase>())..getAllFavouriteWords(),
      lazy: false,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBarCustom(
            leading: const Icon(Icons.cloud_sync_sharp),
            textTitle: LocaleKeys.favourite_favourites.tr(),
            enablePadding: true,
            action: GestureDetector(
              onTap: () => _onClearAll(context),
              child: const Icon(Icons.remove_done_outlined),
            ),
          ),
          body: BlocBuilder<WordFavouriteCubit, WordFavouriteState>(
            builder: (context, state) {
              if (state is WordFavouriteLoadingState) {
                return const LoadingIndicatorPage();
              }
              if (state is WordFavouriteErrorState) {
                return ErrorPage(text: state.message);
              }
              if (state is WordFavouriteLoadedState) {
                favourteNotifer.value = state.words;
                return RefreshIndicator(
                  onRefresh: () async => _onRefresh(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50.h,
                        width: context.screenWidth,
                        margin: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 15.w,
                        ).copyWith(top: 15.h),
                        child: SearchFavouriteWordWidget(
                          onSearch: (value) => _onSearch(context, value),
                        ),
                      ),
                      Expanded(
                        child: _buildFavourites(),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  Widget _buildFavourites() {
    return ValueListenableBuilder(
      valueListenable: favourteNotifer,
      builder: (context, favourites, _) {
        return ListView.builder(
          itemCount: favourites.length,
          // physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w),
              child: Material(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(8.r),
                child: InkWell(
                  onTap: () => _onOpenWordDetail(context, favourites[index]),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 15.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ListTileCustom(
                      title: TextCustom(favourites[index].word.toLowerCase()),
                      trailing: GestureDetector(
                        onTap: () => _onRemoveItem(favourites[index].word),
                        child: SvgPicture.asset(
                          AppAssets.closeCircle,
                          colorFilter: ColorFilter.mode(
                            context.greyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
