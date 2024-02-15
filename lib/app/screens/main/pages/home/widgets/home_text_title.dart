part of '../home_page.dart';

class _HomeTextTitle extends StatelessWidget {
  const _HomeTextTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextCustom(
      text,
      style: context.textStyle.titleS.bold.bw,
    );
  }
}
