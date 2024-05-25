import 'dart:convert';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

import '../models/bubble.dart';

class SaveFileWeb {
  static void saveCsv(List<Bubble> bubbles, String filename) {
    final List<String> header = bubbles.first.toMap().keys.toList();
    final StringBuffer buffer = StringBuffer();
    buffer.write(header.join(';'));
    for (final Bubble b in bubbles) {
      buffer.write("\n$b");
    }
    final List<int> bytes = utf8.encode(buffer.toString());
    final web.HTMLAnchorElement anchor =
        web.document.createElement('a') as web.HTMLAnchorElement
          ..href = "data:application/octet-stream;base64,${base64Encode(bytes)}"
          ..style.display = 'none'
          ..download = '$filename.csv';

    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
  }

  static void saveImage(Uint8List bytes, String filename) {
    final web.HTMLAnchorElement anchor =
        web.document.createElement('a') as web.HTMLAnchorElement
          ..href = "data:application/octet-stream;base64,${base64Encode(bytes)}"
          ..style.display = 'none'
          ..download = '$filename.png';

    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
  }
}
