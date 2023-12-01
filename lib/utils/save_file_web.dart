import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

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
    final html.Blob blob = html.Blob(<List<int>>[bytes]);
    final String url = html.Url.createObjectUrlFromBlob(
      blob,
    );
    final html.AnchorElement anchor =
        html.document.createElement('a') as html.AnchorElement
          // ignore: unsafe_html
          ..href = url
          ..style.display = 'none'
          ..download = '$filename.csv';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  static void saveImage(Uint8List bytes, String filename) {
    final html.Blob blob = html.Blob(<dynamic>[bytes], 'text/plain', 'native');

    html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(blob),
    )
      ..download = '$filename.png'
      ..click();
  }
}
