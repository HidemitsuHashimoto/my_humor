/// Stub for saving image to gallery on web (gal not supported).
Future<void> saveImageBytesToGallery(
  List<int> bytes, {
  required String name,
  String album = 'Screenshots',
}) async {
  throw UnsupportedError('Save to gallery is not supported on web');
}

/// Placeholder for web - not used (always throws UnsupportedError before).
class GallerySaveException implements Exception {
  GallerySaveException(this.message);
  final String message;
}
