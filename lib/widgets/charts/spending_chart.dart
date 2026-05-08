import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mintyn/core/dimensions.dart';
import '../../core/constants.dart';

class SpendingChart extends StatefulWidget {
  final List<double> data;
  final List<String> labels;
  final double height;

  const SpendingChart({
    super.key,
    required this.data,
    required this.labels,
    this.height = 200,
  });

  @override
  State<SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<SpendingChart>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  Offset? _selectedPosition;
  late AnimationController _animController;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _drawAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTapOrDrag(Offset localPosition, Size size) {
    if (widget.data.isEmpty) return;
    final double stepX = size.width / (widget.data.length - 1);
    int idx = (localPosition.dx / stepX)
        .round()
        .clamp(0, widget.data.length - 1);
    setState(() {
      _selectedIndex = idx;
      _selectedPosition = localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) => _handleTapOrDrag(
          d.localPosition, Size(context.size!.width, widget.height)),
      onPanUpdate: (d) => _handleTapOrDrag(
          d.localPosition, Size(context.size!.width, widget.height)),
      child: AnimatedBuilder(
        animation: _drawAnimation,
        builder: (_, __) => CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _SpendingChartPainter(
            data: widget.data,
            labels: widget.labels,
            selectedIndex: _selectedIndex,
            animationProgress: _drawAnimation.value,
          ),
        ),
      ),
    );
  }
}

class _SpendingChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final int? selectedIndex;
  final double animationProgress;

  _SpendingChartPainter({
    required this.data,
    required this.labels,
    required this.selectedIndex,
    required this.animationProgress,
  });

  static const double _labelHeight = 28;
  static const double _topPadding = 16;
  static const double _bPadding = 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartH = size.height - _labelHeight - _topPadding - _bPadding;
    final double minVal = data.reduce(min);
    final double maxVal = data.reduce(max);
    final double range = max(maxVal - minVal, 1);

    
    final double stepX = size.width / (data.length - 1);

    List<Offset> rawPoints = [];
    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double normalised = (data[i] - minVal) / range;
      final double y = _topPadding + chartH * (1 - normalised);
      rawPoints.add(Offset(x, y));
    }

    
    final int maxI = ((data.length - 1) * animationProgress).floor();
    final double frac = ((data.length - 1) * animationProgress) - maxI;
    List<Offset> points = rawPoints.sublist(0, maxI + 1);
    if (maxI < data.length - 1) {
      final Offset interp =
          Offset.lerp(rawPoints[maxI], rawPoints[maxI + 1], frac)!;
      points = [...points, interp];
    }

    if (points.length < 2) return;

    
    final path = _buildSmoothPath(points);

    
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, _topPadding + chartH)
      ..lineTo(points.first.dx, _topPadding + chartH)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.chartFillTop.withOpacity(0.55),
        AppColors.chartFillBottom,
      ],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, _topPadding, size.width, chartH),
      );
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.chartLine
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    
    const labelStyle = TextStyle(
      color: Color(0xffC3C3C3),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
    );
    final double labelY = size.height - _labelHeight - _bPadding + 6;
    for (int i = 0; i < labels.length; i++) {
      final double x = i * stepX;
      _drawLabel(
        canvas,
        labels[i],
        Offset(x, labelY),
        labelStyle,
        size.width,
        index: i,
        total: labels.length,
      );
    }

    
    if (selectedIndex != null &&
        selectedIndex! < points.length &&
        selectedIndex! < data.length) {
      final Offset pt = rawPoints[selectedIndex!];

      _drawDashedLine(
        canvas,
        Offset(pt.dx, _topPadding),
        Offset(pt.dx, _topPadding + chartH),
        Paint()
          ..color = const Color(0xffDEDEDE)
          ..strokeWidth = 1,
      );

      canvas.drawCircle(
        pt, 6,
        Paint()
          ..color = AppColors.textPrimary
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        pt, 4,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill,
      );

      _drawTooltip(canvas, pt, data[selectedIndex!], size);
    }
  }

  Path _buildSmoothPath(List<Offset> pts) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1x = pts[i].dx + (pts[i + 1].dx - pts[i].dx) / 2;
      final cp2x = pts[i + 1].dx - (pts[i + 1].dx - pts[i].dx) / 2;
      path.cubicTo(
        cp1x, pts[i].dy,
        cp2x, pts[i + 1].dy,
        pts[i + 1].dx, pts[i + 1].dy,
      );
    }
    return path;
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style,
    double maxWidth, {
    required int index,
    required int total,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    double dx;
    if (index == 0) {
      
      dx = center.dx;
    } else if (index == total - 1) {
      
      dx = center.dx - tp.width;
    } else {
      
      dx = center.dx - tp.width / 2;
    }

    tp.paint(canvas, Offset(dx, center.dy));
  }

  void _drawDashedLine(Canvas c, Offset from, Offset to, Paint paint) {
    const double dashLen = 5;
    const double gapLen = 4;
    final total = (to - from).distance;
    final dir = (to - from) / total;
    double drawn = 0;
    bool drawing = true;
    while (drawn < total) {
      final segLen = drawing ? dashLen : gapLen;
      final end = drawn + segLen;
      if (drawing) {
        c.drawLine(
          from + dir * drawn,
          from + dir * min(end, total),
          paint,
        );
      }
      drawn = end;
      drawing = !drawing;
    }
  }

  void _drawTooltip(Canvas canvas, Offset pt, double value, Size size) {
    final label =
        '\$${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const hPad = 10.0;
    const vPad = 6.0;
    final tooltipW = tp.width + hPad * 2;
    final tooltipH = tp.height + vPad * 2;
    const radius = 8.0;

    
    double tx = pt.dx - tooltipW / 2;
    tx = tx.clamp(0.0, size.width - tooltipW);
    double ty = pt.dy - tooltipH - 12;
    if (ty < 0) ty = pt.dy + 12;

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tx, ty, tooltipW, tooltipH),
      const Radius.circular(radius),
    );

    canvas.drawRRect(
      tooltipRect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    tp.paint(canvas, Offset(tx + hPad, ty + vPad));
  }

  @override
  bool shouldRepaint(_SpendingChartPainter old) =>
      old.data != data ||
      old.selectedIndex != selectedIndex ||
      old.animationProgress != animationProgress;
}