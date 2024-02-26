import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';

import '../../../../app/constants/app_asset.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/managers/shared_preferences.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../config/app_logger.dart';
import '../../../../injection_container.dart';

class FavouriteButtonWidget extends StatefulWidget {
  const FavouriteButtonWidget({super.key, required this.word});

  final String word;

  @override
  State<FavouriteButtonWidget> createState() => _FavouriteButtonWidgetState();
}

class _FavouriteButtonWidgetState extends State<FavouriteButtonWidget> {
  ValueNotifier<bool> favourite = ValueNotifier(false);
  ValueNotifier<bool> executing = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    favourite.value =
        sl<SharedPrefManager>().getFavouriteWords.contains(widget.word);
  }

  Future<void> _onTapFavourite(bool isLiked) async {
    if (!isLiked) {
      await sl<SharedPrefManager>().addFavouriteWord(widget.word);
      Navigators().showMessage(
        "Added '${widget.word.toLowerCase()}' to favourite!",
        type: MessageType.success,
        duration: 2,
      );
    } else {
      await sl<SharedPrefManager>().removeFavouriteWord(widget.word);
      Navigators().showMessage(
        "Removed '${widget.word.toLowerCase()}' from favourite!",
        type: MessageType.success,
        duration: 2,
      );
    }
    executing.value = false;
    favourite.value = !isLiked;
    logger.d('Favourites: ${sl<SharedPrefManager>().getFavouriteWords}');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: favourite,
      builder: (context, bool isLiked, _) {
        return LikeButton(
          size: 28.h,
          isLiked: isLiked,
          onTap: (isLiked) async {
            if (!executing.value) {
              executing.value = true;
              await _onTapFavourite(isLiked);
              return isLiked;
            }
            return null;
          },
          likeBuilder: (_) {
            final color = isLiked ? AppColor().red : AppColor().grey400;
            return SvgPicture.asset(
              isLiked ? AppAssets.loved : AppAssets.love,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            );
          },
        );
      },
    );
  }
}
