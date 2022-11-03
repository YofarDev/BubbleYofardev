import 'package:flutter/material.dart';

class TalkingTriangleOfBubble extends StatelessWidget {
  final Offset center;
  final Offset talkingPoint;
  final Size sizeBubble;
  final bool movingMode;

  const TalkingTriangleOfBubble({
    super.key,
    required this.center,
    required this.talkingPoint,
    required this.sizeBubble,
    required this.movingMode,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
        talkingPoint,
        center,
        sizeBubble,
        movingMode: movingMode,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

//////////////////////////////// WIDGETS ////////////////////////////////

//////////////////////////////// LISTENERS ////////////////////////////////

//////////////////////////////// FUNCTIONS ////////////////////////////////
}

class TrianglePainter extends CustomPainter {
  late Paint _painterBg;
  late Paint _painterLine;
  late Offset _talkingPoint;
  late Offset _centerPoint;
  late Size _sizeBubble;

  TrianglePainter(
    Offset point,
    Offset center,
    Size sizeBubble, {
    required bool movingMode,
  }) {
    _talkingPoint = point;
    _centerPoint = center;
    _sizeBubble = sizeBubble;

    _painterBg = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    _painterLine = Paint()
      ..color = movingMode ? Colors.red : Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path bg = Path();
    final int vy = _isBelow() ? 1 : -1;
    final int vx = _isOnLeft() ? 1 : -1;
    final Offset end1 = Offset(
      _centerPoint.dx - _sizeBubble.width / 10,
      _centerPoint.dy + (_sizeBubble.height / 2 * vy) - (2.4 * vy),
    );
    final Offset end2 = Offset(
      _centerPoint.dx + _sizeBubble.width / 10,
      _centerPoint.dy + (_sizeBubble.height / 2 * vy) - (2.4 * vy),
    );

    // White triangle
    bg.moveTo(_talkingPoint.dx, _talkingPoint.dy);
    bg.lineTo(end1.dx, end1.dy);
    bg.lineTo(end2.dx, end2.dy);
    bg.close();
    canvas.drawPath(bg, _painterBg);

    // Two black lines
    final Path lines = Path();
    lines.moveTo(_talkingPoint.dx, _talkingPoint.dy);
    lines.close();
    canvas.drawLine(_talkingPoint, end1, _painterLine);
    canvas.drawLine(_talkingPoint, end2, _painterLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  bool _isBelow() => _talkingPoint.dy > _centerPoint.dy;
  bool _isOnLeft() => _talkingPoint.dx < _centerPoint.dy;
}
