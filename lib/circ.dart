// Add this class to create a custom painter for the progress indicator
import 'dart:math';

import 'package:flutter/material.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double value;
  final double strokeWidth;
  final double radius;
  final Gradient gradient1;
  final Gradient gradient2;

  const GradientCircularProgressIndicator({
    required Key key,
    required this.value,
    this.strokeWidth = 4.0,
    this.radius = 50.0,
    required this.gradient1,
    required this.gradient2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outer full circle
        CustomPaint(
          size: Size(radius, radius),
          painter: _GradientCircularProgressPainter(
            value: 1, // Full circle
            strokeWidth: strokeWidth - 5.0, // Smaller stroke width
            gradient: gradient1,
          ),
        ),
        // Inner progress circle
        CustomPaint(
          size: Size(radius, radius),
          painter: _GradientCircularProgressPainter(
            value: value,
            strokeWidth: strokeWidth,
            gradient: gradient2,
          ),
        ),
      ],
    );
  }
}
class _GradientCircularProgressPainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final Gradient gradient;

  _GradientCircularProgressPainter({
    required this.value,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round 
      ..shader = gradient.createShader(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2,
        ),
      );

    canvas.drawArc(
      Offset.zero & size,
      -pi / 2,
      2 * pi * value,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradient != gradient;
  }
}
