// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TalkingTriangleOfBubble extends StatelessWidget {
  final Offset center;
  final Offset talkingPoint;
  final Size sizeBubble;
  final bool movingMode;
  final double widthBaseTriangle;

  const TalkingTriangleOfBubble({
    super.key,
    required this.center,
    required this.talkingPoint,
    required this.sizeBubble,
    required this.movingMode,
    required this.widthBaseTriangle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
        talkingPoint,
        center,
        sizeBubble,
        widthBaseTriangle,
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
  late double _widthBaseTriangle;

  TrianglePainter(
    Offset point,
    Offset center,
    Size sizeBubble,
    double widthBaseTriangle, {
    required bool movingMode,
  }) {
    _talkingPoint = point;
    _centerPoint = center;
    _sizeBubble = sizeBubble;
    _widthBaseTriangle = widthBaseTriangle;

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

    final Offset end1 = Offset(
      _getPointCenter().dx - _widthBaseTriangle,
      _getPointCenter().dy + (_sizeBubble.height / 2 * vy) - (2.5 * vy),
    );
    final Offset end2 = Offset(
      _getPointCenter().dx + _widthBaseTriangle,
      _getPointCenter().dy + (_sizeBubble.height / 2 * vy) - (2.5 * vy),
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

  Offset _getPointCenter() {
    final double min =
        _centerPoint.dx - _sizeBubble.width / 2 + _widthBaseTriangle + 20;
    final double max =
        _centerPoint.dx + _sizeBubble.width / 2 - _widthBaseTriangle - 20;
    if (_talkingPoint.dx < min) {
      return Offset(min, _centerPoint.dy);
    } else if (_talkingPoint.dx > max) {
      return Offset(max, _centerPoint.dy);
    } else {
      return Offset(_talkingPoint.dx, _centerPoint.dy);
    }
  }
}
