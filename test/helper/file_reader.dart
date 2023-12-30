import 'dart:io';

class TestHelper {
  TestHelper._();

  static String readJson(String path) {
    var dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }
    return File('$dir/$path').readAsStringSync();
  }

  static File readFile(String path) {
    var dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }
    return File('$dir/$path');
  }
}
