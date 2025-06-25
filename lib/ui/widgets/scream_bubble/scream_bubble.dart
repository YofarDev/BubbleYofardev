import 'dart:math';

import 'package:flutter/material.dart';

class ScreamBubble extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double padding;

  /// Controls the depth/height of the spikes.
  final double bumpiness;

  /// Controls the frequency/width of the spikes. A smaller value means more, thinner spikes.
  final double jaggedness;

  const ScreamBubble({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
    this.padding = 30.0,
    this.bumpiness = 15.0,
    this.jaggedness = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScreamBubblePainter(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        bumpiness: bumpiness,
        jaggedness: jaggedness,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class ScreamBubblePainter extends CustomPainter {
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double bumpiness;
  final double jaggedness;

  ScreamBubblePainter({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.bumpiness = 15.0,
    this.jaggedness = 25.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _generateJaggedPath(size);

    if (backgroundColor != null) {
      canvas.drawPath(path, Paint()..color = backgroundColor!);
    }

    if (borderColor != null && borderWidth > 0) {
      canvas.drawPath(
          path,
          Paint()
            ..color = borderColor!
            ..style = PaintingStyle.stroke
            ..strokeWidth = borderWidth
            ..strokeJoin = StrokeJoin.round);
    }
  }

  Path _generateJaggedPath(Size size) {
    final Path path = Path();
    final Random random = Random((size.width * size.height).toInt());
    final double w = size.width;
    final double h = size.height;

    // A bit of random offset for the start point to make it look more organic
    final double startX = random.nextDouble() * jaggedness * 0.5;
    path.moveTo(startX, 0);

    // Helper function to create a single spike
    double createSpike(double total, double current, double direction) {
      while (current < total) {
        final double segmentWidth = min(
            random.nextDouble() * jaggedness + jaggedness * 0.5,
            total - current);
        final double spikeTipX = current + segmentWidth / 2;
        final double spikeTipY =
            direction * (random.nextDouble() * 0.7 + 0.3) * bumpiness;
        final double endPointX = current + segmentWidth;

        if (direction > 0) {
          // bottom and right edges
          path.lineTo(spikeTipX, total + spikeTipY);
          path.lineTo(endPointX, total);
        } else {
          // top and left edges
          path.lineTo(spikeTipX, spikeTipY);
          path.lineTo(endPointX, 0);
        }
        current = endPointX;
      }
      return current;
    }

    // Top edge (moving right)
    createSpike(w, startX, -1);
    path.lineTo(w, 0);

    // Right edge (moving down)
    path.transform(Matrix4.rotationZ(pi / 2).storage);
    path.transform(
        Matrix4.translationValues(0, w, 0).storage); // Translate after rotation
    createSpike(h, 0, 1);
    path.lineTo(h, 0);
    path.transform(Matrix4.translationValues(h, 0, 0)
        .storage); // Translate before rotating back
    path.transform(Matrix4.rotationZ(-pi / 2).storage);
    path.lineTo(w, h);

    // Bottom edge (moving left)
    path.transform(Matrix4.rotationZ(pi).storage);
    path.transform(
        Matrix4.translationValues(w, h, 0).storage); // Translate after rotation
    createSpike(w, 0, 1);
    path.lineTo(w, 0);
    path.transform(Matrix4.translationValues(w, h, 0)
        .storage); // Translate before rotating back
    path.transform(Matrix4.rotationZ(-pi).storage);
    path.lineTo(0, h);

    // Left edge (moving up)
    path.transform(Matrix4.rotationZ(3 * pi / 2).storage);
    path.transform(
        Matrix4.translationValues(0, h, 0).storage); // Translate after rotation
    createSpike(h, 0, -1);
    path.lineTo(h, 0);
    path.transform(Matrix4.translationValues(0, h, 0)
        .storage); // Translate before rotating back
    path.transform(Matrix4.rotationZ(-3 * pi / 2).storage);

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant ScreamBubblePainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.bumpiness != bumpiness ||
        oldDelegate.jaggedness != jaggedness;
  }
}
