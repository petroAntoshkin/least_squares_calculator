import 'package:flutter/material.dart';
import 'package:least_squares/models/graphic_data.dart';

class DrawPainter extends CustomPainter {
  GraphicData graphicData;
  Listenable repaint;

  DrawPainter({this.repaint, this.graphicData});

  void paint(Canvas canvas, Size size) {
    final double _maxSize = size.width > size.height ? size.height : size.width;
    final double _gridStep = _maxSize / graphicData.gridCount;

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

    if (graphicData.gridCount > 0) {
      final paintGrid = Paint()
        ..color = Colors.grey
        ..strokeWidth = 1.0;

      for (int i = -graphicData.gridCount; i < graphicData.gridCount * 2; i ++) {
        double _tempCoord = i * _gridStep + graphicData.displaceX;
        if(_tempCoord > 0 && _tempCoord < _maxSize)
          canvas.drawLine(Offset(_tempCoord, 0), Offset(_tempCoord, _maxSize), paintGrid);
        _tempCoord = _maxSize - i * _gridStep + graphicData.displaceY;
        if(_tempCoord > 0 && _tempCoord < _maxSize)
          canvas.drawLine(Offset(0, _tempCoord), Offset(_maxSize, _tempCoord), paintGrid);
        // canvas.drawLine(Offset(graphicData.axisArrowOffset * 5, i), Offset(_maxSize - graphicData.axisArrowOffset * 5, i), paintGrid);
      }
    }
    //      Y axis
    canvas.drawLine(Offset(_maxSize / 2 + graphicData.displaceX, 0),
        Offset(_maxSize / 2 + graphicData.displaceX, _maxSize), paintAxis);
    canvas.drawLine(
        Offset(_maxSize / 2 + graphicData.displaceX, 0),
        Offset(_maxSize / 2 + graphicData.axisArrowOffset + graphicData.displaceX,
            graphicData.axisArrowOffset * 2),
        paintAxis);
    canvas.drawLine(
        Offset(_maxSize / 2 + graphicData.displaceX, 0),
        Offset(_maxSize / 2 - graphicData.axisArrowOffset + graphicData.displaceX,
            graphicData.axisArrowOffset * 2),
        paintAxis);

    //      X axis
    canvas.drawLine(Offset(0, _maxSize / 2 + graphicData.displaceY),
        Offset(_maxSize, _maxSize / 2 + graphicData.displaceY), paintAxis);
    canvas.drawLine(
        Offset(_maxSize, _maxSize / 2 + graphicData.displaceY),
        Offset(_maxSize - graphicData.axisArrowOffset * 2,
            _maxSize / 2 - graphicData.axisArrowOffset + graphicData.displaceY),
        paintAxis);
    canvas.drawLine(
        Offset(_maxSize, _maxSize / 2 + graphicData.displaceY),
        Offset(_maxSize - graphicData.axisArrowOffset * 2,
            _maxSize / 2 + graphicData.axisArrowOffset + graphicData.displaceY),
        paintAxis);

    //     draw approximation

    /*if (graphicData.trendDots.length == 2) {
      canvas.drawLine(graphicData.trendDots[0], graphicData.trendDots[1],
          paintMainLine);
    } else */
    if (graphicData.trendDots.length > 0) {
      for (int i = 1; i < graphicData.trendDots.length; i++)
        canvas.drawLine(graphicData.trendDots[i - 1], graphicData.trendDots[i],
            paintMainLine);
    }

    // draw dots
    for (int i = 0; i < graphicData.dataDots.length; i++) {
      canvas.drawCircle(graphicData.dataDots[i], 2.0, paintDots);
    }
  }

  @override
  bool shouldRepaint(DrawPainter oldDelegate) => true;
}
