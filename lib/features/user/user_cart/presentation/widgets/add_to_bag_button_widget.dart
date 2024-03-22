import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/themes/app_color.dart';
import '../cubits/cart/cart_cubit.dart';
import '../cubits/cart_bag/cart_bag_cubit.dart';

class AddToBagButtonWidget extends StatelessWidget {
  const AddToBagButtonWidget({
    super.key,
    required this.bagKey,
    required this.word,
  });

  final GlobalKey bagKey;
  final String word;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, CartState, List<String>>(
      selector: (state) => state is CartLoadedState
          ? state.entity.bags.expand((e) => e.words).toList()
          : [],
      builder: (context, list) {
        return BlocBuilder<CartBagCubit, CartBagState>(
          builder: (context, state) {
            if (state.entity != null) {
              return state.entity!.words.contains(word) || list.contains(word)
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () =>
                          context.read<CartBagCubit>().addToCartBag(word),
                      // child: Icon(
                      //   Icons.add_circle_outline_rounded,
                      //   size: 28.h,
                      //   color: context.colors.blue600,
                      // ),
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w),
                        child: SvgPicture.asset(
                          Assets.icons.addCircle,
                          key: bagKey,
                          height: 28.h,
                          colorFilter: ColorFilter.mode(
                              context.colors.grey400, BlendMode.srcIn),
                        ),
                      ),
                    );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
