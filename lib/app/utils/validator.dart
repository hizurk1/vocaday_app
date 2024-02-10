class Validator {
  Validator._();

  /// A function to validate an email address.
  ///
  /// The function returns `true` if the email address is valid, and `false` if it is not.
  ///
  /// The function uses a regular expression to match the email address against a specific format.
  static bool validateEmail(String email) {
    /// A regular expression pattern to match an email address.
    const String pattern =
        r'^[a-zA-Z0-9_]+(?:\.[a-zA-Z0-9_]+)*@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$';

    /// A regular expression object that matches the email address pattern.
    final RegExp regex = RegExp(pattern);

    /// Returns `true` if the email address matches the pattern, and `false` if it does not.
    return regex.hasMatch(email);
  }

  /// A function to validate a password.
  ///
  /// The function returns `true` if the password is valid, and `false` if it is not.
  ///
  /// The function uses a regular expression to match the password against a specific format.
  static bool validatePassword(String password) {
    /// A regular expression pattern to match a password.
    const String pattern = r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}$';

    /// A regular expression object that matches the password pattern.
    final RegExp regex = RegExp(pattern);

    /// Returns `true` if the password matches the pattern, and `false` if it does not.
    return regex.hasMatch(password);
  }
}
