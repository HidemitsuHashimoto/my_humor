import 'dart:typed_data';

import 'package:gal/gal.dart';

/// Saves image bytes to the gallery (DCIM/Screenshots album on Android).
/// Used on mobile/desktop when dart:io is available.
Future<void> saveImageBytesToGallery(
  List<int> bytes, {
  required String name,
  String album = 'Screenshots',
}) async {
  try {
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (!hasAccess) {
      final granted = await Gal.requestAccess(toAlbum: true);
      if (!granted) {
        throw GallerySaveException('Permissão negada para acessar a galeria.');
      }
    }
    await Gal.putImageBytes(
      bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
      album: album,
      name: name,
    );
  } on GalException catch (e) {
    throw GallerySaveException(e.type.message);
  }
}

/// Exception thrown when saving to gallery fails.
class GallerySaveException implements Exception {
  GallerySaveException(this.message);
  final String message;
}
