class Validator {
  Validator._();

  static bool validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9_]+(?:\.[a-zA-Z0-9_]+)*@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool validatePassword(String password) {
    String pattern = r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }
}
