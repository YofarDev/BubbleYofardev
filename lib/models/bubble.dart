// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class Bubble {
  String uuid;
  String body;
  bool isRound;
  bool isYellowBg;
  Offset position;
  String font;
  double fontSize;
  bool hasTalkingShape;
  Offset? talkingPoint;
  Offset? centerPoint;
  Size? bubbleSize;
  double? widthBaseTriangle;
  late Offset relativeTalkingPoint;
  Bubble({
    required this.uuid,
    required this.body,
    required this.isRound,
    required this.isYellowBg,
    required this.position,
    required this.font,
    required this.fontSize,
    this.hasTalkingShape = false,
    this.talkingPoint,
    this.centerPoint,
    this.bubbleSize,
    this.widthBaseTriangle,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'body': body,
      'isRound': isRound,
      'isYellowBg': isYellowBg,
      'position': position,
      'font': font,
      'fontSize': fontSize,
      'hasTalkingShape': hasTalkingShape,
      'talkingPoint': talkingPoint,
      'centerPoint': centerPoint,
      'bubbleSize': bubbleSize,
      'widthBaseTriangle': widthBaseTriangle,
    };
  }

  factory Bubble.fromMap(Map<String, dynamic> map) {
    return Bubble(
      uuid: map['uuid'] as String,
      body: map['body'] as String,
      isRound: map['isRound'] as bool,
      isYellowBg: map['isYellowBg'] as bool,
      position: map['position'] as Offset,
      font: map['font'] as String,
      fontSize: map['fontSize'] as double,
      hasTalkingShape: map['hasTalkingShape'] as bool,
      talkingPoint: map['talkingPoint'] as Offset?,
      centerPoint: map['centerPoint'] as Offset?,
      bubbleSize: map['bubbleSize'] as Size,
      widthBaseTriangle: map['widthBaseTriangle'] as double,
    );
  }

  factory Bubble.fromCsv(
    List<String> row,
  ) {
    return Bubble(
      uuid: row[0],
      body: row[1],
      isRound: row[2] == 'true',
      isYellowBg: row[3] == 'true',
      position: row[4].toOffset()!,
      font: row[5],
      fontSize: double.parse(row[6]),
      hasTalkingShape: row[7] == 'true',
      talkingPoint: row[8].toOffset(),
      centerPoint: row[9].toOffset(),
      bubbleSize: row[10].toSize(),
      widthBaseTriangle: row[11] != 'null' ? double.parse(row[11]) : null,
    );
  }

  @override
  String toString() {
    return '$uuid;$body;$isRound;$isYellowBg;${position.toCsvString()};$font;$fontSize;$hasTalkingShape;${talkingPoint?.toCsvString()};${centerPoint?.toCsvString()};${bubbleSize?.toCsvString()};$widthBaseTriangle';
  }
}

extension OffsetUtils on Offset {
  String toCsvString() {
    return "$dx//$dy";
  }
}

extension SizeUtils on Size {
  String toCsvString() {
    return "$width//$height";
  }
}

extension Utils on String {
  Offset? toOffset() {
    if (this == 'null') return null;
    final List<String> l = split('//');
    return Offset(double.parse(l[0]), double.parse(l[1]));
  }

  Size? toSize() {
    final List<String> l = split('//');
    return Size(double.parse(l[0]), double.parse(l[1]));
  }
}
