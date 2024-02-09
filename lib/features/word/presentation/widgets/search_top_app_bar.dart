import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/app_asset.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/translations/translations.dart';
import '../blocs/search_word/search_word_bloc.dart';

class SearchTopAppBar extends StatefulWidget {
  const SearchTopAppBar({super.key});

  @override
  State<SearchTopAppBar> createState() => _SearchTopAppBarState();
}

class _SearchTopAppBarState extends State<SearchTopAppBar> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSubmitEvent({required String keyword}) {
    context
        .read<SearchWordBloc>()
        .add(SearchWordByKeywordEvent(keyword: keyword));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.theme.dividerColor.withOpacity(.45),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          controller: _textController,
          onChanged: (value) => _onSubmitEvent(keyword: value),
          onSubmitted: (value) => _onSubmitEvent(keyword: value),
          maxLines: 1,
          maxLength: 20,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: SvgPicture.asset(
              AppAssets.searchIcon,
              height: 25.h,
              width: 25.w,
              colorFilter: ColorFilter.mode(
                context.colors.grey300,
                BlendMode.srcIn,
              ),
            ),
            hintText: LocaleKeys.search_search_for_words.tr(),
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
              color: context.colors.grey,
            ),
            counterText: '',
            contentPadding: EdgeInsets.zero,
            suffixIcon: GestureDetector(
              onTap: () {
                _onSubmitEvent(keyword: '');
                _textController.clear();
              },
              child: Icon(
                Icons.clear,
                color: context.colors.grey600,
              ),
            ),
          ),
          keyboardType: TextInputType.text,
          cursorWidth: 2,
          cursorColor: context.theme.primaryColor,
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}
