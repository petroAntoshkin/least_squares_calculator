import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DrawPainter extends CustomPainter {

  bool drawGrid = false;
  DrawPainter({this.drawGrid});
  void paint(Canvas canvas, Size size){
    const AXIS_OFFSET = 5.0;
    final pointMode = ui.PointMode.polygon;
    final yTop = Offset(AXIS_OFFSET, AXIS_OFFSET);
    final coordStart = Offset(AXIS_OFFSET, size.height - AXIS_OFFSET);
    final xTop = Offset(size.width - AXIS_OFFSET, size.height - AXIS_OFFSET);
    final points = [
      Offset(0, AXIS_OFFSET * 3),
      yTop,
      Offset(AXIS_OFFSET * 2, AXIS_OFFSET * 3),
      yTop,
      coordStart,
      xTop,
    ];
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(DrawPainter oldDelegate) => false;
}