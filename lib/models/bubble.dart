// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum BubbleType { talk, thought}

class Bubble extends Equatable {
  final BubbleType type;
  final String uuid;
  final String body;
  final bool isRound;
  final bool isYellowBg;
  final Offset position;
  final String font;
  final double fontSize;
  final bool hasTalkingShape;
  final Offset? talkingPoint;
  final Offset? centerPoint;
  final Size? bubbleSize;
  final double? widthBaseTriangle;
  final Offset? relativeTalkingPoint;
  final double? maxWidthBubble;
  const Bubble({
    this.type = BubbleType.talk,
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
    this.maxWidthBubble,
    this.relativeTalkingPoint,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'body': body,
      'type': type,
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
      'maxWidthBubble': maxWidthBubble,
    };
  }

  factory Bubble.fromCsv(
    List<String> row,
  ) {
    return Bubble(
      uuid: row[0],
      body: row[1].replaceAll('[[NL]]', '\n'),
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
      maxWidthBubble: row[12] != 'null' ? double.parse(row[12]) : null,
      relativeTalkingPoint: row[13].toOffset(),
      type:
          row.length > 14 ? BubbleType.values.byName(row[14]) : BubbleType.talk,
    );
  }

  @override
  String toString() {
    return '$uuid;${body.replaceAll('\n', '[[NL]]')};$isRound;$isYellowBg;${position.toCsvString()};$font;$fontSize;$hasTalkingShape;${talkingPoint?.toCsvString()};${centerPoint?.toCsvString()};${bubbleSize?.toCsvString()};$widthBaseTriangle;$maxWidthBubble;${relativeTalkingPoint?.toCsvString()};${type.name};';
  }

  @override
  // TODO: implement props
  List<Object?> get props {
    return <Object?>[
      uuid,
      body,
      type,
      isRound,
      isYellowBg,
      position,
      font,
      fontSize,
      hasTalkingShape,
      talkingPoint,
      centerPoint,
      bubbleSize,
      widthBaseTriangle,
      relativeTalkingPoint,
      maxWidthBubble,
    ];
  }

  Bubble copyWith({
    BubbleType? type,
    String? uuid,
    String? body,
    bool? isRound,
    bool? isYellowBg,
    Offset? position,
    String? font,
    double? fontSize,
    bool? hasTalkingShape,
    Offset? talkingPoint,
    Offset? centerPoint,
    Size? bubbleSize,
    double? widthBaseTriangle,
    Offset? relativeTalkingPoint,
    double? maxWidthBubble,
  }) {
    return Bubble(
      type: type ?? this.type,
      uuid: uuid ?? this.uuid,
      body: body ?? this.body,
      isRound: isRound ?? this.isRound,
      isYellowBg: isYellowBg ?? this.isYellowBg,
      position: position ?? this.position,
      font: font ?? this.font,
      fontSize: fontSize ?? this.fontSize,
      hasTalkingShape: hasTalkingShape ?? this.hasTalkingShape,
      talkingPoint: talkingPoint ?? this.talkingPoint,
      centerPoint: centerPoint ?? this.centerPoint,
      bubbleSize: bubbleSize ?? this.bubbleSize,
      widthBaseTriangle: widthBaseTriangle ?? this.widthBaseTriangle,
      relativeTalkingPoint: relativeTalkingPoint ?? this.relativeTalkingPoint,
      maxWidthBubble: maxWidthBubble ?? this.maxWidthBubble,
    );
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
