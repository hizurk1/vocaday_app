import 'package:flutter/material.dart';

import '../../app/translations/translations.dart';

extension StringNullExt on String? {
  TimeOfDay? get toTimeOfDay {
    if (this == null) return null;
    final values = this!.split(':');
    final now = DateTime.now();
    return TimeOfDay.fromDateTime(DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(values.first),
      int.parse(values.last),
    ));
  }

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
  /// Short of `replaceAll(r'\n', '\n')`
  String get fixBreakLine => replaceAll(r'\n', '\n');

  /// Format: `1000` to `1,000`
  String get formatedThousand {
    List<String> parts = split(' ');
    int number = int.tryParse(parts.first) ?? 0;

    if (number < 1000) return this;

    // Format the number with commas
    String formatted = number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );

    // Return the formatted string
    return "$formatted ${parts.last}";
  }

  /// Parse string to DateTime format with pattern `dd/MM/yyyy`.
  ///
  /// Example:
  ///
  /// '11/02/2024'.toDate; // Returns DateTime(2024, 02, 11)
  DateTime get toDate => DateFormat("dd/MM/yyyy").parse(this);

  /// Returns a copy of this string with the first character converted to uppercase.
  ///
  /// If the string is empty, this method returns an empty string.
  ///
  /// Example:
  ///
  ///     'hello world'.capitalizeFirstLetter; // Returns 'Hello world'
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    if (length < 2) return toUpperCase();
    return this[0].toUpperCase() + substring(1);
  }

  /// Returns a copy of this string with the first character converted to lowercase.
  ///
  /// If the string is empty, this method returns an empty string.
  ///
  /// Example:
  ///
  ///     'Hello World'.uncapitalizeFirstLetter; // Returns 'hello World'
  String get uncapitalizeFirstLetter {
    if (isEmpty) return this;
    if (length < 2) return toLowerCase();
    return this[0].toLowerCase() + substring(1);
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
