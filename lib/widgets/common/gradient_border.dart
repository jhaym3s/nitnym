import 'package:flutter/material.dart';

class GradientBorderPainter extends CustomPainter {
  const GradientBorderPainter({required this.borderRadius});

  final double borderRadius;

  static const _gradient = LinearGradient(
    begin: Alignment(-0.846, -0.533),
    end: Alignment(0.846, 0.533),
    colors: [
      Color.fromRGBO(212, 211, 211, 0.480),
      Color.fromRGBO(44, 43, 43, 0.285),
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.0;
    final inset = strokeWidth / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(borderRadius),
    );
    final shader =
        _gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(GradientBorderPainter old) =>
      old.borderRadius != borderRadius;
}