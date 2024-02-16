import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/constants/app_asset.dart';
import '../../../../../app/managers/navigation.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/error_page.dart';
import '../../../../../app/widgets/gap.dart';
import '../../../../../app/widgets/loading_indicator.dart';
import '../../../../../app/widgets/pushable_button.dart';
import '../../../../../app/widgets/text.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../domain/entities/word_entity.dart';
import '../../blocs/word_list/word_list_cubit.dart';
import 'cubits/daily_word/daily_word_cubit.dart';
import 'cubits/random_image/random_image_cubit.dart';

class MainNewWordPanelWidget extends StatefulWidget {
  const MainNewWordPanelWidget({super.key});

  @override
  State<MainNewWordPanelWidget> createState() => _MainNewWordPanelWidgetState();
}

class _MainNewWordPanelWidgetState extends State<MainNewWordPanelWidget> {
  Future<void> _onReload(BuildContext context) async {
    await context.read<DailyWordCubit>().reload();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DailyWordCubit(), lazy: false),
        BlocProvider(
          create: (_) =>
              RandomImageCubit()..getRandomImage(const Size(600, 300)),
          lazy: false,
        ),
      ],
      child: BlocBuilder<WordListCubit, WordListState>(
        builder: (context, state) {
          if (state is WordListLoadingState) {
            return const LoadingIndicatorPage();
          }
          if (state is WordListErrorState) {
            return ErrorPage(text: state.message);
          }
          if (state is WordListLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<DailyWordCubit>().getDailyWord(state.wordList);
            });

            return Container(
              width: context.screenWidth,
              height: 205.h,
              margin: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    children: [
                      _buildBackgroundImage(constraints.maxHeight),
                      _buildBlackBlur(constraints.maxHeight),
                      _buildContent(),
                      _buildLearnMoreButton(),
                      _buildReloadButton(state.wordList),
                    ],
                  ),
                );
              }),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildReloadButton(List<WordEntity> list) {
    return BlocBuilder<DailyWordCubit, DailyWordState>(
      builder: (context, state) {
        if (state is DailyWordLoadingState) {
          return Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: const LoadingIndicatorWidget(),
            ),
          );
        }
        return GestureDetector(
          onTap: () => _onReload(context),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: SvgPicture.asset(
                AppAssets.reload,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  AppColor().white.withOpacity(.5),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLearnMoreButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h, right: 20.w),
        child: PushableButton(
          onPressed: () {},
          text: LocaleKeys.home_learn_more.tr(),
          width: max(100, context.screenWidth * 0.3),
          height: 46,
          elevation: 3,
          textStyle: context.textStyle.caption.white,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<DailyWordCubit, DailyWordState>(
      listener: (context, state) {
        if (state is DailyWordErrorState) {
          Navigators().showMessage(state.message, type: MessageType.error);
        }
      },
      builder: (context, state) {
        WordEntity? entity;
        if (state is DailyWordLoadedState) {
          entity = state.entity;
        }
        return Container(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCustom(
                entity?.word.toLowerCase() ?? ' ',
                style: context.textStyle.titleM.white.bold,
              ),
              const Gap(height: 5),
              TextCustom(
                entity != null
                    ? '(${entity.meanings.first.type.toLowerCase()})'
                    : ' ',
                style: context.textStyle.bodyS.grey300,
              ),
              const Gap(height: 8),
              TextCustom(
                entity?.meanings.first.meaning.toLowerCase() ?? ' ',
                maxLines: 2,
                style: context.textStyle.bodyS.white,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBlackBlur(double parentHeight) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
      child: Container(
        width: context.screenWidth,
        height: parentHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor().black.withOpacity(0.7),
              AppColor().black.withOpacity(0.9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(double parentHeight) {
    return BlocBuilder<RandomImageCubit, RandomImageState>(
      builder: (context, state) {
        if (state is RandomImageLoadingState) {
          return Container(color: Colors.black);
        }
        if (state is RandomImageLoadedState) {
          return Image.memory(
            state.imageBytes,
            width: context.screenWidth,
            height: parentHeight,
            fit: BoxFit.cover,
          );
        }
        return const SizedBox();
      },
    );
  }
}
