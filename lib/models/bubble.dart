// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum BubbleType { talk, thought, scream, narrate, yellowNarrate }

class Bubble extends Equatable {
  final BubbleType type;
  final String uuid;
  final String body;
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
  final int seed;
  const Bubble({
    this.type = BubbleType.talk,
    required this.uuid,
    required this.body,
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
    required this.seed,
  });

  Map<String, dynamic> toCsvMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'body': body,
      'position': position.toCsvString(),
      'font': font,
      'fontSize': fontSize,
      'hasTalkingShape': hasTalkingShape,
      'talkingPoint': talkingPoint?.toCsvString() ?? '',
      'centerPoint': centerPoint?.toCsvString() ?? '',
      'bubbleSize': bubbleSize?.toCsvString() ?? '',
      'widthBaseTriangle': widthBaseTriangle ?? '',
      'maxWidthBubble': maxWidthBubble ?? '',
      'relativeTalkingPoint': relativeTalkingPoint?.toCsvString() ?? '',
      'type': type.name,
      'seed': seed,
    };
  }

  factory Bubble.fromMap(Map<String, dynamic> map) {
    double? maxWidthBubble;
    try {
      maxWidthBubble = double.parse(map['maxWidthBubble'] as String);
    } catch (e) {
      maxWidthBubble = null;
    }
    double? widthBaseTriangle;
    try {
      widthBaseTriangle = double.parse(map['widthBaseTriangle'] as String);
    } catch (e) {
      widthBaseTriangle = null;
    }
    return Bubble(
        uuid: map['uuid'] as String,
        body: map['body'] as String,
        position: (map['position'] as String).toOffset()!,
        font: map['font'] as String,
        fontSize: (map['fontSize'] as num).toDouble(),
        hasTalkingShape:
            map['hasTalkingShape'] == true || map['hasTalkingShape'] == 'true',
        talkingPoint: (map['talkingPoint'] as String?)?.toOffset(),
        centerPoint: (map['centerPoint'] as String?)?.toOffset(),
        bubbleSize: (map['bubbleSize'] as String?)?.toSize(),
        widthBaseTriangle: widthBaseTriangle,
        maxWidthBubble: maxWidthBubble,
        relativeTalkingPoint:
            (map['relativeTalkingPoint'] as String?)?.toOffset(),
        type: BubbleType.values.byName(map['type'] as String),
        seed: map['seed'] as int);
  }

  @override
  List<Object?> get props {
    return <Object?>[
      uuid,
      body,
      type,
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
      seed
    ];
  }

  Bubble copyWith(
      {BubbleType? type,
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
      int? seed}) {
    return Bubble(
        type: type ?? this.type,
        uuid: uuid ?? this.uuid,
        body: body ?? this.body,
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
        seed: seed ?? this.seed);
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
    if (this == 'null' || isEmpty) return null;
    final List<String> l = split('//');
    return Offset(double.parse(l[0]), double.parse(l[1]));
  }

  Size? toSize() {
    final List<String> l = split('//');
    return Size(double.parse(l[0]), double.parse(l[1]));
  }
}
