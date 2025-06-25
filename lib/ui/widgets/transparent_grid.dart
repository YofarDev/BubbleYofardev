import 'package:flutter/material.dart';

class TransparentGrid extends StatelessWidget {
  final double squareSize;

  final Color lightColor;

  final Color darkColor;

  const TransparentGrid({
    super.key,
    this.squareSize = 20.0,
    this.lightColor = const Color(0xFFE0E0E0),
    this.darkColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckerboardPainter(
        squareSize: squareSize,
        lightColor: lightColor,
        darkColor: darkColor,
      ),
    );
  }
}

class _CheckerboardPainter extends CustomPainter {
  final double squareSize;
  final Color lightColor;
  final Color darkColor;

  const _CheckerboardPainter({
    required this.squareSize,
    required this.lightColor,
    required this.darkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint lightPaint = Paint()..color = lightColor;
    final Paint darkPaint = Paint()..color = darkColor;

    final int horizontalCount = (size.width / squareSize).ceil() + 1;
    final int verticalCount = (size.height / squareSize).ceil() + 1;

    for (int y = 0; y < verticalCount; y++) {
      for (int x = 0; x < horizontalCount; x++) {
        final Paint paint = (x + y) % 2 == 0 ? lightPaint : darkPaint;

        final Rect rect = Rect.fromLTWH(
          x * squareSize,
          y * squareSize,
          squareSize,
          squareSize,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_CheckerboardPainter oldDelegate) {
    return oldDelegate.squareSize != squareSize ||
        oldDelegate.lightColor != lightColor ||
        oldDelegate.darkColor != darkColor;
  }
}
