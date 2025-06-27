import 'dart:convert';

import 'package:csv/csv.dart';

import '../models/bubble.dart';

class BubbleCsvService {
  static const List<String> _headers = <String>[
    'uuid',
    'body',
    'position',
    'font',
    'fontSize',
    'hasTalkingShape',
    'talkingPoint',
    'centerPoint',
    'bubbleSize',
    'widthBaseTriangle',
    'maxWidthBubble',
    'relativeTalkingPoint',
    'type',
    'seed',
  ];

  static Future<List<int>> toBytes(List<Bubble> bubbles) async {
    final List<Map<String, dynamic>> bubbleMaps =
        bubbles.map((Bubble bubble) => bubble.toCsvMap()).toList();
    final List<List<dynamic>> rows = <List<dynamic>>[];
    rows.add(_headers);
    for (final Map<String, dynamic> map in bubbleMaps) {
      rows.add(_headers.map((String header) => map[header]).toList());
    }
    const ListToCsvConverter converter = ListToCsvConverter();
    final String csvString = converter.convert(rows);
    return utf8.encode(csvString);
  }

  static Future<List<Bubble>> loadBubbles(String csvString) async {
    const CsvToListConverter converter =
        CsvToListConverter(shouldParseNumbers: true, eol: '\n');
    final List<List<dynamic>> rows = converter.convert(csvString);
    if (rows.length < 2) {
      return <Bubble>[];
    }
    final List<String> headerRow = rows.first
        .map((dynamic e) =>
            e.toString().trim().replaceAll(RegExp(r'[\uFEFF]'), ''))
        .toList();
    final List<List<dynamic>> dataRows = rows.sublist(1);
    final List<Map<String, dynamic>> maps = <Map<String, dynamic>>[];
    for (final List<dynamic> row in dataRows) {
      maps.add(Map<String, dynamic>.fromIterables(headerRow, row));
    }
    return maps.map((Map<String, dynamic> map) => Bubble.fromMap(map)).toList();
  }
}
