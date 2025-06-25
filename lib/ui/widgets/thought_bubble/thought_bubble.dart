import 'package:flutter/material.dart';

class ThoughtBubble extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double padding;
  final double bumpiness;
  final bool movingMode;

  const ThoughtBubble({
    super.key,
    required this.child,
    this.movingMode = false,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
    this.padding = 20.0,
    this.bumpiness = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ThoughtBubblePainter(
        backgroundColor: backgroundColor,
        borderColor: movingMode ? Colors.red : borderColor,
        borderWidth: borderWidth,
        bumpiness: bumpiness,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class ThoughtBubblePainter extends CustomPainter {
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double bumpiness;

  ThoughtBubblePainter({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.bumpiness = 15.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Path path = Path();

    path.moveTo(0, height * 0.5);

    path.quadraticBezierTo(
      -bumpiness,
      height * 0.2,
      width * 0.1,
      0,
    );

    path.quadraticBezierTo(
      width * 0.2,
      -bumpiness,
      width * 0.5,
      0,
    );
    path.quadraticBezierTo(
      width * 0.8,
      -bumpiness * 0.8,
      width * 0.9,
      0,
    );

    path.quadraticBezierTo(
      width + bumpiness,
      height * 0.3,
      width,
      height * 0.6,
    );

    path.quadraticBezierTo(
      width,
      height + bumpiness,
      width * 0.7,
      height,
    );
    path.quadraticBezierTo(
      width * 0.3,
      height + bumpiness * 1.2,
      width * 0.2,
      height,
    );

    path.quadraticBezierTo(
      -bumpiness * 0.8,
      height * 0.9,
      0,
      height * 0.5,
    );

    path.close();

    if (backgroundColor != null) {
      final Paint fillPaint = Paint()
        ..color = backgroundColor!
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    if (borderColor != null && borderWidth > 0) {
      final Paint borderPaint = Paint()
        ..color = borderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ThoughtBubblePainter) {
      return oldDelegate.backgroundColor != backgroundColor ||
          oldDelegate.borderColor != borderColor ||
          oldDelegate.borderWidth != borderWidth ||
          oldDelegate.bumpiness != bumpiness;
    }
    return true;
  }
}
