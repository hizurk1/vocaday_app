class UtilFunction {
  UtilFunction._();

  static String splitFirst(String? text, String pattern) =>
      text?.split(pattern).first ?? '';
}
