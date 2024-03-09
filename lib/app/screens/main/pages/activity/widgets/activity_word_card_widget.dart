import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/extensions/string.dart';
import '../../../../../../features/user/user_profile/presentation/widgets/favourite/favourite_button_widget.dart';
import '../../../../../../features/word/domain/entities/word_entity.dart';
import '../../../../../constants/gen/assets.gen.dart';
import '../../../../../themes/app_color.dart';
import '../../../../../themes/app_text_theme.dart';
import '../../../../../translations/translations.dart';
import '../../../../../widgets/widgets.dart';

class FlipCardController {
  _WordCardWidgetState? _state;
  Future flipCard() async => _state?.flipCard();
  void resetCard() => _state?.resetCard();
}

class WordCardWidget extends StatefulWidget {
  const WordCardWidget({
    super.key,
    required this.entity,
    required this.controller,
    required this.onTap,
    required this.onLongPress,
  });

  final WordEntity entity;
  final FlipCardController controller;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  State<WordCardWidget> createState() => _WordCardWidgetState();
}

class _WordCardWidgetState extends State<WordCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isFront = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    widget.controller._state = this;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> flipCard() async {
    // if (_animationController.isAnimating) return;
    isFront = !isFront;

    if (isFront) {
      await _animationController.reverse();
    } else {
      await _animationController.forward();
    }
  }

  void resetCard() => _animationController.reset();

  bool isFrontCard(double angle) => angle <= pi / 2 || angle >= 3 * pi / 2;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final angle = _animationController
                .drive(CurveTween(curve: Curves.fastOutSlowIn))
                .value *
            pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        return GestureDetector(
          onTap: widget.onTap,
          onLongPress: isFront ? null : widget.onLongPress,
          child: Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isFrontCard(angle.abs())
                ? _CardContent(isFront: true, entity: widget.entity)
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _CardContent(isFront: false, entity: widget.entity),
                  ),
          ),
        );
      },
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.isFront, required this.entity});

  final bool isFront;
  final WordEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      height: context.screenHeight,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 2.5,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            isFront ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.arrowHorizontal,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  context.greyColor.withOpacity(.8),
                  BlendMode.srcIn,
                ),
              ),
              const Gap(width: 8),
              TextCustom(
                LocaleKeys.common_skip.tr(),
                style: context.textStyle.caption.copyWith(
                  color: context.colors.grey300
                      .withOpacity(context.isDarkTheme ? .35 : .8),
                ),
              ),
              const Spacer(),
              TextCustom(
                LocaleKeys.activity_add_to_cart.tr(),
                style: context.textStyle.caption.copyWith(
                  color: context.colors.grey300
                      .withOpacity(context.isDarkTheme ? .35 : .8),
                ),
              ),
              const Gap(width: 8),
              SvgPicture.asset(
                Assets.icons.sharedUp,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  context.greyColor.withOpacity(.8),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: isFront
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextCustom(
                  entity.word.toLowerCase(),
                  style: context.textStyle.titleM.bold.bw,
                  maxLines: 3,
                ),
                const Gap(height: 5),
                TextCustom(
                  "(${entity.meanings.first.type.toLowerCase()})",
                  style: context.textStyle.bodyM.grey,
                ),
                if (!isFront) ...[
                  const Gap(height: 10),
                  TextCustom(
                    "${entity.meanings.first.meaning.toLowerCase().capitalizeFirstLetter}.",
                    style: context.textStyle.bodyM.grey,
                    maxLines: 10,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ],
            ),
          ),
          Row(
            children: [
              SvgPicture.asset(
                isFront ? Assets.icons.flipIcon : Assets.icons.handPoint,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  context.greyColor.withOpacity(.8),
                  BlendMode.srcIn,
                ),
              ),
              const Gap(width: 10),
              TextCustom(
                isFront
                    ? LocaleKeys.activity_tap_to_rotate.tr()
                    : LocaleKeys.activity_hold_for_detail.tr(),
                style: context.textStyle.caption.copyWith(
                  color: context.colors.grey300
                      .withOpacity(context.isDarkTheme ? .35 : .8),
                ),
              ),
              const Spacer(),
              if (!isFront)
                Opacity(
                  opacity: 0.8,
                  child: FavouriteButtonWidget(word: entity.word),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
