import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/widgets/text.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/number.dart';
import '../cubits/cart_bag/cart_bag_cubit.dart';
import '../pages/word_bag_bottom_sheet_page.dart';

class CartIconWidget extends StatelessWidget {
  const CartIconWidget({super.key, this.marginRight});

  final double? marginRight;

  Future<void> _onOpenCartBottomSheet(BuildContext context) async {
    await context.showBottomSheet(
      child: WordBagBottomSheetPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onOpenCartBottomSheet(context),
      child: Container(
        height: 40.r,
        width: 40.r,
        margin: EdgeInsets.only(right: marginRight?.w ?? 20.w),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 25.dm,
              color: context.theme.primaryColorDark,
            ),
            BlocBuilder<CartBagCubit, CartBagState>(
              builder: (context, state) {
                final count = state.entity?.words.length ?? 0;
                return Positioned(
                  top: 2.r,
                  right: 2.r,
                  child: AnimatedOpacity(
                    duration: Durations.short4,
                    opacity: count > 0 ? 1 : 0,
                    child: ClipOval(
                      child: Container(
                        height: 18.r,
                        width: 18.r,
                        color: context.theme.colorScheme.error,
                        child: Center(
                          child: TextCustom(
                            count.to99plus,
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
