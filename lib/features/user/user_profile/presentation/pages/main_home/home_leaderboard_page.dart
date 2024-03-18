import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../../app/themes/app_text_theme.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../app/widgets/widgets.dart';
import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/extensions/string.dart';
import '../../../domain/entities/user_entity.dart';
import '../../cubits/leader_board/leader_board_cubit.dart';

enum LeaderboardType { point, attendance }

class HomeLeaderboardPage extends StatefulWidget {
  final LeaderboardType type;
  const HomeLeaderboardPage({
    super.key,
    required this.type,
  });

  @override
  State<HomeLeaderboardPage> createState() => _HomeLeaderboardPageState();
}

class _HomeLeaderboardPageState extends State<HomeLeaderboardPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: BlocBuilder<LeaderBoardCubit, LeaderBoardState>(
        builder: (context, state) {
          if (state is LeaderBoardLoadingState) {
            return const Wrap(children: [LoadingIndicatorPage()]);
          }
          if (state is LeaderBoardErrorState) {
            return Wrap(children: [ErrorPage(text: state.message)]);
          }
          if (state is LeaderBoardLoadedState) {
            final listUser = widget.type == LeaderboardType.point
                ? state.points
                : state.attendances;
            final topList = listUser.getRange(0, listUser.length).toList();

            return Wrap(
              children: [
                _TopRankingBlock(
                  topUsers: topList,
                  type: widget.type,
                ),
                if (listUser.length > 3)
                  ...listUser
                      .getRange(3, listUser.length)
                      .mapIndexed((i, e) => _LeaderBoardTileWidget(
                            index: i + 3,
                            entity: e,
                            type: widget.type,
                          )),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _TopRankingBlock extends StatelessWidget {
  final List<UserEntity> topUsers;
  final LeaderboardType type;

  const _TopRankingBlock({required this.topUsers, required this.type});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 385.dm,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: context.isDarkTheme ? .8 : 1,
                child: SvgPicture.asset(
                  Assets.images.leaderboardBox,
                  width: context.screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              top: constraints.maxHeight * 0.03,
              left: constraints.maxWidth * 0.05,
              right: constraints.maxWidth * 0.05,
              child: LayoutBuilder(builder: (context, inConstraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TopUserRank(
                      index: 1,
                      inConstraints: inConstraints,
                      outConstraints: constraints,
                      type: type,
                      entity: topUsers.length > 1 ? topUsers[1] : null,
                    ),
                    _TopUserRank(
                      index: 0,
                      inConstraints: inConstraints,
                      outConstraints: constraints,
                      type: type,
                      entity: topUsers.isNotEmpty ? topUsers[0] : null,
                    ),
                    _TopUserRank(
                      index: 2,
                      inConstraints: inConstraints,
                      outConstraints: constraints,
                      type: type,
                      entity: topUsers.length > 2 ? topUsers[2] : null,
                    ),
                  ],
                );
              }),
            )
          ],
        );
      }),
    );
  }
}

class _TopUserRank extends StatelessWidget {
  final BoxConstraints inConstraints;
  final BoxConstraints outConstraints;
  final int index;
  final UserEntity? entity;
  final LeaderboardType type;

  const _TopUserRank({
    required this.inConstraints,
    required this.outConstraints,
    required this.index,
    required this.entity,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: outConstraints.maxHeight * 0.12 * 0.75 * index,
      ),
      width: inConstraints.maxWidth / 3 - 10.w,
      child: entity != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImageCustom(
                  url: entity?.avatar,
                  size: 70,
                ),
                Gap(height: 5.h),
                TextCustom(
                  entity?.name ?? '',
                  style: context.textStyle.bodyS.bold.primaryDark,
                ),
                Gap(height: 5.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 6.w,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor.withOpacity(.75),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextCustom(
                    entity != null
                        ? type == LeaderboardType.point
                            ? LocaleKeys.user_data_point
                                .plural(entity?.point ?? 0)
                                .formatedThousand
                            : LocaleKeys.home_time
                                .plural(entity?.attendance?.length ?? 0)
                                .formatedThousand
                        : '',
                    style: context.textStyle.caption.bold.white,
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}

class _LeaderBoardTileWidget extends StatelessWidget {
  final LeaderboardType type;
  final UserEntity entity;
  final int index;

  const _LeaderBoardTileWidget({
    required this.type,
    required this.entity,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(.2),
            offset: const Offset(0, 2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTileCustom(
        leading: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: CachedNetworkImageCustom(
            url: entity.avatar,
            size: 50,
            allowOpenFullscreenImage: false,
          ),
        ),
        titlePadding: EdgeInsets.symmetric(horizontal: 8.w),
        title: TextCustom(
          entity.name,
          style: context.textStyle.bodyS.bold.bw,
        ),
        subTitle: TextCustom(
          type == LeaderboardType.point
              ? LocaleKeys.user_data_point.plural(entity.point).formatedThousand
              : LocaleKeys.home_time.plural(entity.attendance?.length ?? 0),
          style: context.textStyle.labelL.grey,
        ),
        trailing: Container(
          height: 30.dm,
          width: 30.dm,
          margin: EdgeInsets.only(left: 10.w, right: 15.w),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            border: Border.all(
              color: context.greyColor.withOpacity(.75),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: TextCustom(
              '${index + 1}',
              style: context.textStyle.labelL.bold.grey,
            ),
          ),
        ),
      ),
    );
  }
}
