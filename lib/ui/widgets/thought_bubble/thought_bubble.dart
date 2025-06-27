import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A widget that displays text inside a cloud-shaped thought bubble.
///
/// The shape of the cloud is deterministic based on the [randomSeed] provided.
class ThoughtBubble extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color bubbleColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final bool isSelected;
  final double? maxWidth;

  /// A seed for the random number generator to create a deterministic cloud shape.
  /// Providing the same seed will always result in the same shape for the same size.
  final int randomSeed;

  /// Controls how much the cloud puffs bulge outwards. Values around 1.0 are standard.
  /// Smaller values (<1.0) make the cloud flatter, larger values (>1.0) make it puffier.
  final double puffiness;

  const ThoughtBubble({
    super.key,
    required this.text,
    this.textStyle,
    this.bubbleColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 2,
    this.padding =
        const EdgeInsets.all(20.0), // Increased padding for cloud shape
    this.isSelected = false,
    this.maxWidth,
    this.randomSeed = 42, // Default seed for consistency
    this.puffiness = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    int puffcount;
    if (maxWidth != null) {
      puffcount = (maxWidth! / 10).toInt();
    } else {
      puffcount = math.max(15, text.length);
    }
    return CustomPaint(
      painter: CloudBubblePainter(
        bubbleColor: bubbleColor,
        borderColor: isSelected ? Colors.red : borderColor,
        borderWidth: borderWidth,
        randomSeed: randomSeed,
        puffCount: puffcount,
        puffiness: puffiness,
      ),
      child: Container(
        padding: padding,
        width: maxWidth,
        // Using a constrained box to provide the painter with a definitive size
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}

class CloudBubblePainter extends CustomPainter {
  final Color bubbleColor;
  final Color borderColor;
  final double borderWidth;
  final int randomSeed;
  final int puffCount;
  final double puffiness;

  CloudBubblePainter({
    required this.bubbleColor,
    required this.borderColor,
    required this.borderWidth,
    required this.randomSeed,
    required this.puffCount,
    required this.puffiness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bubblePaint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeJoin = StrokeJoin.round;

    final Path path = _createCloudyPath(size);

    canvas.drawPath(path, bubblePaint);
    canvas.drawPath(path, borderPaint);
  }

  Path _createCloudyPath(Size size) {
    final Path path = Path();
    // Use a Random instance seeded to ensure deterministic shapes
    final math.Random random = math.Random(randomSeed);

    final List<Offset> points = <Offset>[];
    final double width = size.width;
    final double height = size.height;
    final double perimeter = (width + height) * 2;
    final double step = perimeter / puffCount;

    // Distribute points along the perimeter of the bounding box
    for (int i = 0; i < puffCount; i++) {
      final double distanceAlongPerimeter =
          i * step + random.nextDouble() * step * 0.8 - step * 0.4;

      Offset point;
      if (distanceAlongPerimeter < width) {
        // Top edge
        point = Offset(distanceAlongPerimeter, 0);
      } else if (distanceAlongPerimeter < width + height) {
        // Right edge
        point = Offset(width, distanceAlongPerimeter - width);
      } else if (distanceAlongPerimeter < width * 2 + height) {
        // Bottom edge
        point =
            Offset(width - (distanceAlongPerimeter - width - height), height);
      } else {
        // Left edge
        point =
            Offset(0, height - (distanceAlongPerimeter - width * 2 - height));
      }
      points.add(point);
    }

    if (points.isEmpty) {
      return path;
    }

    // Start the path at the last point to ensure a smooth loop
    path.moveTo(points.last.dx, points.last.dy);

    // Create the cloud puffs by drawing arcs between the points
    for (int i = 0; i < points.length; i++) {
      final Offset currentPoint = points[i];
      final Offset nextPoint = points[(i + 1) % points.length];

      // Calculate the distance between points to determine the radius of the puff
      final double distance = (nextPoint - currentPoint).distance;

      // The radius is based on the distance, puffiness, and a bit of randomness
      final double radiusValue = distance /
          2 *
          (0.8 +
              random.nextDouble() *
                  0.4) * // Random variation for a natural look
          puffiness;

      path.arcToPoint(
        currentPoint,
        radius: Radius.circular(math.max(5.0, radiusValue)),
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CloudBubblePainter oldDelegate) {
    // Repaint if any of the visual properties change
    return oldDelegate.bubbleColor != bubbleColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.randomSeed != randomSeed ||
        oldDelegate.puffCount != puffCount ||
        oldDelegate.puffiness != puffiness;
  }
}
