class Validator {
  Validator._();

  /// A function to validate an email address.
  ///
  /// The function returns `true` if the email address is valid, and `false` if it is not.
  ///
  /// The pattern matches strings that follow the format of `"username@domain.com"`,
  /// where the username can contain alphanumeric characters and underscores,
  /// and the domain can contain alphanumeric characters, hyphens, and dots.
  static bool validateEmail(String email) {
    const String pattern =
        r'^[a-zA-Z0-9_]+(?:\.[a-zA-Z0-9_]+)*@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$';

    return RegExp(pattern).hasMatch(email);
  }

  /// A function to validate a password.
  ///
  /// The function returns `true` if the password is valid, and `false` if it is not.
  ///
  /// Pattern means that the password should contains:
  ///
  /// * `(?=.*[a-zA-Z])`: at least one alphabetical character.
  /// * `(?=.*\d)`: at least one digit.
  /// * `[a-zA-Z\d]{8,}`: at least 8 characters. These characters can be a combination of uppercase letters, lowercase letters, and digits.
  static bool validatePassword(String password) {
    const String pattern = r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}$';

    return RegExp(pattern).hasMatch(password);
  }

  /// A function to validate a phone number.
  ///
  /// The function returns `true` if the phoneNumber is valid, and `false` if it is not.
  ///
  /// The pattern accepts international phone numbers that start with a `+` or `0` followed by 6 to 10 digits.
  ///
  /// Examples of valid strings that match this pattern:
  /// * +1234567890
  /// * 0123456789
  /// * +44987654
  static bool validatePhoneNumber(String phoneNumber) {
    const String pattern = r'^(\+[0-9]{1,2}|0)+[0-9]{6,10}$';

    return RegExp(pattern).hasMatch(phoneNumber);
  }
}
