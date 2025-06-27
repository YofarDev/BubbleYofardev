import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImageUtils {
  static Future<Uint8List> trimTransparentPixels(Uint8List bytes) async {
    final img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      return bytes;
    }
    final List<int> rect = img.findTrim(image);
    final int x = rect[0];
    final int y = rect[1];
    final int width = rect[2];
    final int height = rect[3];
    final img.Image trimmed = img.copyCrop(
      image,
      x: x,
      y: y,
      width: width,
      height: height,
    );
    return img.encodePng(trimmed);
  }
}
