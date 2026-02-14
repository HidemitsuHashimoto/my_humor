/// Stub for saving image to file on web (dart:io not available).
Future<void> saveImageBytesToPath(List<int> bytes, String path) async {
  throw UnsupportedError('Save image is not supported on web');
}
