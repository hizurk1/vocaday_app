import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/build_context.dart';
import '../constants/gen/assets.gen.dart';
import '../themes/app_color.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.autofocus = false,
  });

  final String hintText;
  final Function(String input) onSearch;
  final bool autofocus;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _textController;
  ValueNotifier<bool> showClearIcon = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() {
      if (_textController.text.isNotEmpty && !showClearIcon.value) {
        showClearIcon.value = true;
      } else if (_textController.text.isEmpty && showClearIcon.value) {
        showClearIcon.value = false;
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 10.w),
      decoration: BoxDecoration(
        // border: context.isDarkTheme
        //     ? null
        //     : Border.all(
        //         color: context.theme.dividerColor.withOpacity(.45),
        //       ),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(.5),
            offset: const Offset(0, .5),
            blurRadius: 0,
            spreadRadius: 1.2,
          ),
        ],
        color:
            context.isDarkTheme ? context.colors.grey900 : context.colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: _textController,
        onChanged: (value) => widget.onSearch(value),
        onSubmitted: (value) => widget.onSearch(value),
        maxLines: 1,
        maxLength: 20,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: SvgPicture.asset(
            Assets.icons.searchOutline,
            height: 25.h,
            width: 25.w,
            colorFilter: ColorFilter.mode(
              context.colors.grey300,
              BlendMode.srcIn,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp,
            color: context.colors.grey,
          ),
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 5.dm),
          suffixIcon: ValueListenableBuilder<bool>(
            valueListenable: showClearIcon,
            builder: (context, isShow, _) {
              return isShow
                  ? GestureDetector(
                      onTap: () {
                        if (_textController.text.isNotEmpty) {
                          widget.onSearch('');
                          _textController.clear();
                        }
                      },
                      child: Icon(
                        Icons.clear,
                        color: context.colors.grey600,
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ),
        keyboardType: TextInputType.text,
        cursorWidth: 2,
        cursorColor: context.theme.primaryColor,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
