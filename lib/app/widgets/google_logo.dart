import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A self-contained, asset-free rendering of the Google "G" mark.
class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  double _r(double degrees) => degrees * math.pi / 180.0;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.23;
    final radius = (size.width - stroke) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    // Ring split into the four brand colors (angles clockwise from east).
    paint.color = const Color(0xFF4285F4); // blue
    canvas.drawArc(rect, _r(-50), _r(50), false, paint);
    paint.color = const Color(0xFF34A853); // green
    canvas.drawArc(rect, _r(40), _r(80), false, paint);
    paint.color = const Color(0xFFFBBC05); // yellow
    canvas.drawArc(rect, _r(120), _r(90), false, paint);
    paint.color = const Color(0xFFEA4335); // red
    canvas.drawArc(rect, _r(210), _r(100), false, paint);

    // Blue crossbar pointing inward from the right edge.
    final barPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);
    final bar = Rect.fromLTRB(
      center.dx,
      center.dy - stroke / 2,
      center.dx + radius + stroke / 2,
      center.dy + stroke / 2,
    );
    canvas.drawRect(bar, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
