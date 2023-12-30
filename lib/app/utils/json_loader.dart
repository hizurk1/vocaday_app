import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class JsonLoader {
  JsonLoader._();
  static Future<Map<String, dynamic>> load(String path) async {
    final stringData = await rootBundle.loadString(path);
    return jsonDecode(stringData);
  }
}
