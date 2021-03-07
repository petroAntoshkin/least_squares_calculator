import 'package:flutter/material.dart';
import 'package:least_squares/models/graphic_data.dart';

class DrawPainter extends CustomPainter {
  GraphicData _graphicData;

  DrawPainter(GraphicData graphicData) {
    _graphicData = graphicData;
  }

  void paint(Canvas canvas, Size size) {
    final double _maxSize = size.width > size.height ? size.height : size.width;
    const AXIS_OFFSET = 4.0;
    final double _gridStep = _maxSize / _graphicData.gridCount;

    final paintAxis = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final paintMainLine = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final paintDots = Paint()
      ..color = Colors.green
      ..strokeWidth = 1.0;

    if (_graphicData.gridCount > 0) {
      final paintGrid = Paint()
        ..color = Colors.grey
        ..strokeWidth = 1.0;

      for (double i = _maxSize / 2; i < _maxSize; i += _gridStep) {
        canvas.drawLine(Offset(i, 0), Offset(i, _maxSize), paintGrid);
        canvas.drawLine(
            Offset(_maxSize - i, 0), Offset(_maxSize - i, _maxSize), paintGrid);

        canvas.drawLine(Offset(0, i), Offset(_maxSize, i), paintGrid);
        canvas.drawLine(
            Offset(0, _maxSize - i), Offset(_maxSize, _maxSize - i), paintGrid);
        // canvas.drawLine(Offset(AXIS_OFFSET * 5, i), Offset(_maxSize - AXIS_OFFSET * 5, i), paintGrid);
      }
    }
    //      Y axis
    canvas.drawLine(
        Offset(_maxSize / 2 + _graphicData.displaceX, _graphicData.displaceY),
        Offset(_maxSize / 2 + _graphicData.displaceX,
            _maxSize + _graphicData.displaceY),
        paintAxis);
    canvas.drawLine(
        Offset(_maxSize / 2 + _graphicData.displaceX, _graphicData.displaceY),
        Offset(_maxSize / 2 + AXIS_OFFSET + _graphicData.displaceX,
            AXIS_OFFSET * 2 + _graphicData.displaceY),
        paintAxis);
    canvas.drawLine(
        Offset(_maxSize / 2 + _graphicData.displaceX, _graphicData.displaceY),
        Offset(_maxSize / 2 - AXIS_OFFSET + _graphicData.displaceX,
            AXIS_OFFSET * 2 + _graphicData.displaceY),
        paintAxis);

    //      X axis
    canvas.drawLine(
        Offset(_graphicData.displaceX, _maxSize / 2 + _graphicData.displaceY),
        Offset(_maxSize + _graphicData.displaceX,
            _maxSize / 2 + _graphicData.displaceY),
        paintAxis);
    canvas.drawLine(
        Offset(_maxSize + _graphicData.displaceX,
            _maxSize / 2 + _graphicData.displaceY),
        Offset(_maxSize - AXIS_OFFSET * 2 + _graphicData.displaceX,
            _maxSize / 2 - AXIS_OFFSET + _graphicData.displaceY),
        paintAxis);
    canvas.drawLine(
        Offset(_maxSize + _graphicData.displaceX, _maxSize / 2),
        Offset(_maxSize - AXIS_OFFSET * 2 + _graphicData.displaceX,
            _maxSize / 2 + AXIS_OFFSET + _graphicData.displaceY),
        paintAxis);

    //     draw approximation

    /*if (_graphicData.trendDots.length == 2) {
      canvas.drawLine(_graphicData.trendDots[0], _graphicData.trendDots[1],
          paintMainLine);
    } else */
    if (_graphicData.trendDots.length > 0) {
      for (int i = 1; i < _graphicData.trendDots.length; i++)
        canvas.drawLine(_graphicData.trendDots[i - 1],
            _graphicData.trendDots[i], paintMainLine);
    }

    // draw dots
    for (int i = 0; i < _graphicData.dataDots.length; i++) {
      canvas.drawCircle(_graphicData.dataDots[i], 2.0, paintDots);
    }
  }

  @override
  bool shouldRepaint(DrawPainter oldDelegate) => false;
}
