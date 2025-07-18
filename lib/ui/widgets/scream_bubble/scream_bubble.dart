import 'dart:math' as math;

import 'package:flutter/material.dart';

class ScreamBubble extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color bubbleColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final double jaggedIntensity;
  final bool isSelected;
  final double? maxWidth;
  final double fontSize;
  const ScreamBubble({
    super.key,
    required this.text,
    this.textStyle,
    this.bubbleColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 2,
    this.padding = const EdgeInsets.all(20),
    this.jaggedIntensity = 8,
    this.isSelected = false,
    this.maxWidth,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: JaggedBubblePainter(
        bubbleColor: bubbleColor,
        borderColor: isSelected ? Colors.red : borderColor,
        borderWidth: borderWidth,
        jaggedIntensity: jaggedIntensity,
        textLength: maxWidth != null ? maxWidth!.toInt() : text.length,
      ),
      child: Container(
        padding: padding,
        width: maxWidth,
        child: Center(
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}

class JaggedBubblePainter extends CustomPainter {
  final Color bubbleColor;
  final Color borderColor;
  final double borderWidth;
  final double jaggedIntensity;
  final int textLength;

  JaggedBubblePainter({
    required this.bubbleColor,
    required this.borderColor,
    required this.borderWidth,
    required this.jaggedIntensity,
    required this.textLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeJoin = StrokeJoin.round;
    final Path path = _createJaggedPath(size);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  Path _createJaggedPath(Size size) {
    final Path path = Path();
    final double bubbleHeight = size.height;
    final double bubbleWidth = size.width;
    final double perimeter = 2 * (bubbleWidth + bubbleHeight);
    final int numPoints = (perimeter / 8).round();
    final List<Offset> points = <Offset>[];
    final int topPoints = (numPoints * 0.3).round();
    for (int i = 0; i <= topPoints; i++) {
      final double x = (i / topPoints) * bubbleWidth;
      const double baseY = 0.0;
      final int spikeDirection = i.isEven ? -1 : 1;
      final double jaggedY = baseY +
          spikeDirection *
              (0.3 + math.Random(i + 100).nextDouble() * 0.7) *
              jaggedIntensity;
      points.add(Offset(
          x, math.max(-jaggedIntensity, math.min(jaggedIntensity, jaggedY))));
    }
    final int rightPoints = (numPoints * getSideIntensity(textLength)).round();
    for (int i = 1; i <= rightPoints; i++) {
      final double y = (i / rightPoints) * bubbleHeight;
      final double baseX = bubbleWidth;
      final int spikeDirection = i.isEven ? 1 : -1;
      final double jaggedX = baseX +
          spikeDirection *
              (0.3 + math.Random(i + 200).nextDouble() * 0.7) *
              jaggedIntensity;
      points.add(Offset(
          math.max(-jaggedIntensity,
              math.min(bubbleWidth + jaggedIntensity, jaggedX)),
          y));
    }
    final int bottomPoints = (numPoints * 0.3).round();
    for (int i = 1; i <= bottomPoints; i++) {
      final double x = bubbleWidth - (i / bottomPoints) * bubbleWidth;
      final double baseY = bubbleHeight;
      final int spikeDirection = i.isEven ? 1 : -1;
      final double jaggedY = baseY +
          spikeDirection *
              (0.3 + math.Random(i + 300).nextDouble() * 0.7) *
              jaggedIntensity;
      points.add(Offset(
          x,
          math.max(-jaggedIntensity,
              math.min(bubbleHeight + jaggedIntensity, jaggedY))));
    }
    final int leftPoints = (numPoints * getSideIntensity(textLength)).round();
    for (int i = 1; i < leftPoints; i++) {
      final double y = bubbleHeight - (i / leftPoints) * bubbleHeight;
      const double baseX = 0.0;
      final int spikeDirection = i.isEven ? -1 : 1;
      final double jaggedX = baseX +
          spikeDirection *
              (0.3 + math.Random(i + 400).nextDouble() * 0.7) *
              jaggedIntensity;
      points.add(Offset(
          math.max(-jaggedIntensity, math.min(jaggedIntensity, jaggedX)), y));
    }
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
    }
    return path;
  }

  double getSideIntensity(int textLength) {
    const double minIntensity = 0.05;
    const double maxIntensity = 0.25;
    const int minLength = 1;
    const int maxLength = 20;
    final int clampedLength = textLength.clamp(minLength, maxLength);
    final double normalized =
        (clampedLength - minLength) / (maxLength - minLength);
    final double inverted = 1.0 - normalized;
    final double intensity =
        minIntensity + inverted * (maxIntensity - minIntensity);
    return intensity;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
