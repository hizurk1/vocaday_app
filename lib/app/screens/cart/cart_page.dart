import 'package:flutter/material.dart';

import '../../../core/extensions/build_context.dart';
import '../../../features/user/user_cart/presentation/pages/cart_page_body.dart';
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
          leading: const BackButton(),
          textTitle: LocaleKeys.cart_cart.tr(),
        ),
        body: const CartPageBody(),
      ),
    );
  }
}
