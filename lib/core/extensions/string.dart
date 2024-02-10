extension StringNullExt on String? {
  bool get isNotNullOrEmpty {
    if (this != null && this!.isNotEmpty) return true;
    return false;
  }

  bool get isNullOrEmpty {
    if (this == null) return true;
    if (this!.isEmpty) return true;
    return false;
  }
}

extension StringExtension on String {
  /// Returns a copy of this string with the first character converted to uppercase.
  ///
  /// If the string is empty, this method returns an empty string.
  ///
  /// Example:
  ///
  ///     'hello world'.capitalizeFirstLetter; // Returns 'Hello world'
  String get capitalizeFirstLetter {
    if (length < 2) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Returns the path with the leading slash.
  ///
  /// Example:
  ///
  ///     'hello/world'.routePath; // Returns '/hello/world'
  String get routePath => substring(1);

  /// Returns a copy of this string where each word is capitalized.
  ///
  /// The first character of each word is converted to uppercase and the remaining
  /// characters are converted to lowercase.
  ///
  /// If the string is empty, this method returns an empty string.
  ///
  /// Example:
  ///
  ///     'hello world'.toTitleCase; // Returns 'Hello World'
  String toTitleCase() {
    List<String> words = split(' ');

    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    }

    return words.join(' ');
  }
}
