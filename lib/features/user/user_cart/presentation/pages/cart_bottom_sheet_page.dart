import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../config/app_logger.dart';
import '../../../user_profile/domain/entities/user_entity.dart';
import '../../../user_profile/presentation/cubits/user_data/user_data_cubit.dart';

class CartBottomSheetPage extends StatelessWidget {
  const CartBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserDataCubit, UserDataState, UserEntity?>(
      selector: (state) => state is UserDataLoadedState ? state.entity : null,
      builder: (context, UserEntity? entity) {
        if (entity == null) return const LoadingIndicatorPage();
        return DraggableBottomSheetCustom(
          initialChildSize: 1,
          minChildSize: 0.2,
          textTitle: LocaleKeys.cart_user_cart.tr(args: [entity.name]),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          children: [
            SearchWidget(
              hintText: LocaleKeys.search_search_for_words.tr(),
              onSearch: (input) {
                logger.d(input);
              },
            ),
          ],
        );
      },
    );
  }
}
