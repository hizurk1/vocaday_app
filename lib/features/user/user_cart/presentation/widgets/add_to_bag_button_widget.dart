import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/themes/app_color.dart';
import '../cubits/cart_bag/cart_bag_cubit.dart';

class AddToBagButtonWidget extends StatelessWidget {
  const AddToBagButtonWidget({super.key, required this.word});

  final String word;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBagCubit, CartBagState>(
      builder: (context, state) {
        if (state.entity != null) {
          return state.entity!.words.contains(word)
              ? const SizedBox()
              : GestureDetector(
                  onTap: () => context.read<CartBagCubit>().addToCartBag(word),
                  // child: Icon(
                  //   Icons.add_circle_outline_rounded,
                  //   size: 28.h,
                  //   color: context.colors.blue600,
                  // ),
                  child: Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: SvgPicture.asset(
                      Assets.icons.addCircle,
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
  }
}
