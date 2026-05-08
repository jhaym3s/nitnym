import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mintyn/core/dimensions.dart';


class GradientBorderBlurCard extends StatelessWidget {
  const GradientBorderBlurCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.strokeWidth = 1.0,
    this.blurSigma = 80.0,
    this.backgroundColor,
  });

  final Widget child;
  final double borderRadius;
  final double strokeWidth;
  final double blurSigma;
  final Color? backgroundColor;

  static const _gradient = LinearGradient(
    begin: Alignment(-0.846, -0.533),
    end: Alignment(0.846, 0.533),
    colors: [
      Color.fromRGBO(212, 211, 211, 0.480),
      Color.fromRGBO(44, 43, 43, 0.285),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.transparent,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _NoisePainter()),
            ),
          ),
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GradientBorderPainter(
                  gradient: _gradient,
                  borderRadius: borderRadius,
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04);
    final seed = DateTime.now().microsecondsSinceEpoch;
    for (int i = 0; i < 900; i++) {
      final x = ((seed * (i + 1) * 1234567) % size.width.toInt()).toDouble();
      final y = ((seed * (i + 2) * 7654321) % size.height.toInt()).toDouble();
      canvas.drawCircle(Offset(x.abs(), y.abs()), 1, paint);
    }
  }

  @override
  bool shouldRepaint(_NoisePainter _) => false;
}

class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.gradient,
    required this.borderRadius,
    required this.strokeWidth,
  });

  final LinearGradient gradient;
  final double borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          inset, inset, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(borderRadius),
    );

    final shader =
        gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

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
  bool shouldRepaint(_GradientBorderPainter old) =>
      old.gradient != gradient ||
      old.borderRadius != borderRadius ||
      old.strokeWidth != strokeWidth;
}