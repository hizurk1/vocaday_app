import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/build_context.dart';
import '../../../../app/constants/app_asset.dart';
import '../../../../app/themes/app_color.dart';
import '../../../../app/translations/translations.dart';
import '../blocs/search_word/search_word_bloc.dart';
import '../blocs/word_list/word_list_bloc.dart';

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

  void _onSubmitEvent(
    BuildContext context,
    String value,
    WordListState state,
  ) {
    if (state is WordListLoadedState) {
      context.read<SearchWordBloc>().add(SearchWordByKeywordEvent(
            keyword: value,
            list: state.wordList,
          ));
    }
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
        child: BlocBuilder<WordListBloc, WordListState>(
          builder: (context, state) {
            return TextField(
              controller: _textController,
              onChanged: (value) => _onSubmitEvent(context, value, state),
              onSubmitted: (value) => _onSubmitEvent(context, value, state),
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
                    _onSubmitEvent(context, '', state);
                    _textController.clear();
                  },
                  child: const Icon(
                    Icons.clear,
                    color: Colors.black54,
                  ),
                ),
              ),
              keyboardType: TextInputType.text,
              cursorWidth: 2,
              cursorColor: context.theme.primaryColor,
              textAlignVertical: TextAlignVertical.center,
            );
          },
        ),
      ),
    );
  }
}
