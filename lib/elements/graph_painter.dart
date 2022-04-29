import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:least_squares/models/graphic_data.dart';

class DrawPainter extends CustomPainter {
  ThemeData themeData;
  GraphicData graphicData;
  Listenable repaint;

  DrawPainter({this.repaint, this.graphicData, this.themeData});

  void paint(Canvas canvas, Size size) {
    final double _maxSize = size.width > size.height ? size.height : size.width;
    final double _gridStep = _maxSize / graphicData.gridCount;
    final double _axisXCoord  = _maxSize / 2 + graphicData.displaceX;
    final double _axisYCoord  = _maxSize / 2 + graphicData.displaceY;

    final paintAxis = Paint()
      ..color = themeData.primaryTextTheme.bodyText1.color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final paintMainLine = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final paintDots = Paint()
      ..color = Colors.green
      ..strokeWidth = 1.0;

    final paintBackground = Paint()..color = themeData.backgroundColor;

    canvas.drawRect(
        Rect.fromPoints(Offset.zero, Offset(_maxSize, _maxSize)), paintBackground);
    // if (graphicData.showGrid) {
      final paintGrid = Paint()
        ..color = Colors.grey
        ..strokeWidth = 1.0;

      for (int i = -graphicData.gridCount; i < graphicData.gridCount * 2; i++) {
        double _tempCoord = i * _gridStep + graphicData.displaceX;
        if (_tempCoord > 0 && _tempCoord < _maxSize)
          if(graphicData.showGrid)
            canvas.drawLine(
              Offset(_tempCoord, 0), Offset(_tempCoord, _maxSize), paintGrid);
          else canvas.drawLine(
              Offset(_tempCoord, _axisYCoord - graphicData.axisArrowOffset), Offset(_tempCoord, _axisYCoord + graphicData.axisArrowOffset), paintGrid);
        _tempCoord = _maxSize - i * _gridStep + graphicData.displaceY;
        if (_tempCoord > 0 && _tempCoord < _maxSize)
          if(graphicData.showGrid)
            canvas.drawLine(
              Offset(0, _tempCoord), Offset(_maxSize, _tempCoord), paintGrid);
          else canvas.drawLine(
              Offset(_axisXCoord - graphicData.axisArrowOffset, _tempCoord), Offset(_axisXCoord + graphicData.axisArrowOffset, _tempCoord), paintGrid);
        // canvas.drawLine(Offset(graphicData.axisArrowOffset * 5, i), Offset(_maxSize - graphicData.axisArrowOffset * 5, i), paintGrid);
      }
    // }
    //      Y axis
    canvas.drawLine(Offset(_axisXCoord, 0),
        Offset(_axisXCoord, _maxSize), paintAxis);
    canvas.drawLine(
        Offset(_axisXCoord, 0),
        Offset(
            _maxSize / 2 + graphicData.axisArrowOffset + graphicData.displaceX,
            graphicData.axisArrowOffset * 2),
        paintAxis);
    canvas.drawLine(
        Offset(_axisXCoord, 0),
        Offset(
            _maxSize / 2 - graphicData.axisArrowOffset + graphicData.displaceX,
            graphicData.axisArrowOffset * 2),
        paintAxis);

    //      X axis
    canvas.drawLine(Offset(0, _axisYCoord),
        Offset(_maxSize, _axisYCoord), paintAxis);
    canvas.drawLine(
        Offset(_maxSize, _axisYCoord),
        Offset(_maxSize - graphicData.axisArrowOffset * 2,
            _maxSize / 2 - graphicData.axisArrowOffset + graphicData.displaceY),
        paintAxis);
    canvas.drawLine(
        Offset(_maxSize, _axisYCoord),
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
      switch (graphicData.dotType) {
        case 'square':
          canvas.drawRect(
              Rect.fromCenter(
                center: graphicData.dataDots[i],
                width: graphicData.dotSize * 2,
                height: graphicData.dotSize * 2,
              ),
              paintDots);
          break;
        case 'rhomb':
          Path _path = Path();
          _path.moveTo(
            graphicData.dataDots[i].dx,
            graphicData.dataDots[i].dy - graphicData.dotSize,
          );
          _path.lineTo(
            graphicData.dataDots[i].dx + graphicData.dotSize,
            graphicData.dataDots[i].dy,
          );
          _path.lineTo(
            graphicData.dataDots[i].dx,
            graphicData.dataDots[i].dy + graphicData.dotSize,
          );
          _path.lineTo(
            graphicData.dataDots[i].dx - graphicData.dotSize,
            graphicData.dataDots[i].dy,
          );
          _path.close();
          canvas.drawPath(_path, paintDots);
          break;
        case 'crest':
          canvas.drawRect(
              Rect.fromCenter(
                center: graphicData.dataDots[i],
                width: 2,
                height: graphicData.dotSize * 2,
              ),
              paintDots);
          canvas.drawRect(
              Rect.fromCenter(
                center: graphicData.dataDots[i],
                width: graphicData.dotSize * 2,
                height: 2,
              ),
              paintDots);
          break;
        default:
          canvas.drawCircle(graphicData.dataDots[i], graphicData.dotSize, paintDots);
          break;
      }
      // canvas.drawCircle(graphicData.dataDots[i], 2.0, paintDots);
    }
  }

  @override
  bool shouldRepaint(DrawPainter oldDelegate) => true;
}
