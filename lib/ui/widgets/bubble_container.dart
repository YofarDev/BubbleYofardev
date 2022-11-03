// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

import '../../res/app_colors.dart';

class BubbleContainer extends StatelessWidget {
  final bool isYellowBg;
  final String txt;
  final String font;
  final double fontSize;
  final bool isRoundBubble;
  final bool movingMode;

  const BubbleContainer({
    super.key,
    required this.isYellowBg,
    required this.txt,
    required this.font,
    required this.fontSize,
    required this.isRoundBubble,
    required this.movingMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isRoundBubble ? 12 : 8,
        vertical: isRoundBubble ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: isYellowBg ? AppColors.yellow : Colors.white,
        border:
            Border.all(width: 2, color: movingMode ? Colors.red : Colors.black),
        borderRadius: isRoundBubble ? BorderRadius.circular(100) : null,
      ),
      child: ParsedText(
        text: txt,
        style: TextStyle(fontFamily: font, fontSize: fontSize),
        parse: font == "BottleRocket" ? _fixCaps() : <MatchText>[],
      ),
    );
  }

//////////////////////////////// WIDGETS ////////////////////////////////

  List<MatchText> _fixCaps() => <MatchText>[
        MatchText(
          pattern: "é",
          renderWidget: ({
            required String pattern,
            required String text,
          }) =>
              Text(
            "É",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        MatchText(
          pattern: "è",
          renderWidget: ({
            required String pattern,
            required String text,
          }) =>
              Text(
            "È",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        MatchText(
          pattern: "ê",
          renderWidget: ({
            required String pattern,
            required String text,
          }) =>
              Text(
            "Ê",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        MatchText(
          pattern: "à",
          renderWidget: ({
            required String pattern,
            required String text,
          }) =>
              Text(
            "À",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        MatchText(
          pattern: "ù",
          renderWidget: ({
            required String pattern,
            required String text,
          }) =>
              Text(
            "Ù",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        MatchText(
          pattern: "ç",
          renderWidget: ({
            required String pattern,
            required String text,
          }) =>
              Text(
            "Ç",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ];

//////////////////////////////// LISTENERS ////////////////////////////////

//////////////////////////////// FUNCTIONS ////////////////////////////////
}
