import 'dart:io';

/// Saves image bytes to the given file path. Used on mobile/desktop (dart:io).
Future<void> saveImageBytesToPath(List<int> bytes, String path) async {
  await File(path).writeAsBytes(bytes);
}
