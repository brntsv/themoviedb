import 'dart:math';

import 'package:flutter/material.dart';

class RadialPercentWidget extends StatelessWidget {
  final Widget child;

  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  const RadialPercentWidget(
      {Key? key,
      required this.child,
      required this.percent,
      required this.fillColor,
      required this.lineColor,
      required this.freeColor,
      required this.lineWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: MyPainter(
            percent: percent,
            fillColor: fillColor,
            lineColor: lineColor,
            freeColor: freeColor,
            lineWidth: lineWidth,
          ),
        ),
        Center(child: child),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  MyPainter({
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint();
    backgroundPaint.color = fillColor;
    backgroundPaint.style = PaintingStyle.fill;
    canvas.drawOval(Offset.zero & size, backgroundPaint);

    final unfilledPaint = Paint();
    unfilledPaint.color = freeColor;
    unfilledPaint.style = PaintingStyle.stroke;
    unfilledPaint.strokeWidth = lineWidth;
    canvas.drawArc(
        const Offset(6.5, 6.5) & Size(size.width - 13, size.height - 13),
        pi * 2 * percent - pi / 2,
        pi * 2 * (1.0 - percent),
        false,
        unfilledPaint);

    final filledPaint = Paint();
    filledPaint.color = lineColor;
    filledPaint.style = PaintingStyle.stroke;
    filledPaint.strokeWidth = lineWidth;
    filledPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
        const Offset(6.5, 6.5) & Size(size.width - 13, size.height - 13),
        -pi / 2,
        pi * 2 * percent,
        false,
        filledPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
