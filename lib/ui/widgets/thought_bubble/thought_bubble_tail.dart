import 'package:flutter/material.dart';

class ThoughtBubbleTail extends StatelessWidget {
  final Offset start;
  final Offset end;
  final bool isSelected;

  const ThoughtBubbleTail({
    super.key,
    required this.start,
    required this.end,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ThoughtBubbleTailPainter(start, end, isSelected),
    );
  }
}

class _ThoughtBubbleTailPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final bool isSelected;

  _ThoughtBubbleTailPainter(this.start, this.end, this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = isSelected ? Colors.red : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double distance = (start - end).distance;
    final int circleCount = (distance / 30).clamp(1, 5).toInt();

    for (int i = 0; i < circleCount; i++) {
      final double t = (i + 1) / (circleCount + 1);
      final Offset center = Offset.lerp(start, end, t)!;
      final double radius = 10 * (1 - t * 0.5);
      canvas.drawCircle(center, radius, paint);
      canvas.drawCircle(center, radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is _ThoughtBubbleTailPainter) {
      return oldDelegate.start != start || oldDelegate.end != end;
    }
    return true;
  }
}
