import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../blocs/search_word/search_word_bloc.dart';

class SearchTopAppBar extends StatelessWidget {
  const SearchTopAppBar({super.key});

  void _onSubmitEvent(BuildContext context, String keyword) {
    context
        .read<SearchWordBloc>()
        .add(SearchWordByKeywordEvent(keyword: keyword));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SearchWidget(
        autofocus: true,
        hintText: LocaleKeys.search_search_for_words.tr(),
        onSearch: (value) => _onSubmitEvent(context, value),
      ),
    );
  }
}
