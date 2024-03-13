import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context.dart';
import '../../../features/user/user_cart/presentation/pages/cart_page_body.dart';
import '../../constants/gen/assets.gen.dart';
import '../../routes/route_manager.dart';
import '../../translations/translations.dart';
import '../../widgets/widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBarCustom(
          leading: BackButton(
            style: ButtonStyle(iconSize: MaterialStateProperty.all(24.r)),
          ),
          textTitle: LocaleKeys.cart_cart.tr(),
          action: GestureDetector(
            onTap: () => context.pushReplacement(AppRoutes.listWord),
            child: Container(
              margin: EdgeInsets.only(right: 20.w),
              child: SvgPicture.asset(
                Assets.icons.store,
                height: 25.h,
                colorFilter: ColorFilter.mode(
                    context.theme.primaryColorDark, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        body: const CartPageBody(),
      ),
    );
  }
}
