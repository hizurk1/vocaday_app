import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/widgets/text.dart';
import '../../../../../core/extensions/build_context.dart';
import '../cubits/cart_bag/cart_bag_cubit.dart';
import '../pages/cart_bottom_sheet_page.dart';

class CartIconWidget extends StatelessWidget {
  const CartIconWidget({super.key, this.marginRight});

  final double? marginRight;

  Future<void> _onOpenCartBottomSheet(BuildContext context) async {
    await context.showBottomSheet(
      child: CartBottomSheetPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onOpenCartBottomSheet(context),
      child: Container(
        height: 40.h,
        width: 40.w,
        margin: EdgeInsets.only(right: marginRight?.w ?? 20.w),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 25.h,
              color: context.theme.primaryColorDark,
            ),
            BlocSelector<CartBagCubit, CartBagState, int>(
              selector: (state) => state.status == CartBagStatus.loaded
                  ? (state.entity?.words.length ?? 0)
                  : 0,
              builder: (context, int count) {
                return Positioned(
                  top: 3.h,
                  right: 3.w,
                  child: AnimatedOpacity(
                    duration: Durations.short4,
                    opacity: count > 0 ? 1 : 0,
                    child: ClipOval(
                      child: Container(
                        height: 16.h,
                        width: 16.w,
                        color: context.theme.colorScheme.error,
                        child: Center(
                          child: TextCustom(
                            "$count",
                            style: context.textStyle.labelS.bold.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
