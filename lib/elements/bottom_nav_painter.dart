import 'package:flutter/material.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';

class BottomNavPainter extends CustomPainter {
  Color color;
  double holeHeight = Presets.MINIMUM_TAP_SIZE;

  BottomNavPainter({required this.color, required this.holeHeight});

  final _arcSize = Presets.ARC_SIZE;

  void paint(Canvas canvas, Size size) {
    // double topPartHeight = (size.height - holeHeight).toDouble();
    final Path _path = new Path();
    final paintBgrCurve = Paint()
      ..style = PaintingStyle.fill
      ..color = color //Color(0x55ff0000)
      ..strokeWidth = 1;

    _path.moveTo(0, _arcSize);

    _path.quadraticBezierTo(0, 0, _arcSize, 0);

    _path.lineTo(size.width * 0.4 - _arcSize * 2, 0);
    _path.quadraticBezierTo(size.width * 0.4 - _arcSize, 0, size.width * 0.4 - _arcSize, _arcSize);
    _path.lineTo(size.width * 0.4 - _arcSize, holeHeight - _arcSize);
    _path.quadraticBezierTo(size.width * 0.4 - _arcSize, holeHeight, size.width * 0.4, holeHeight);
    _path.lineTo(size.width * 0.6, holeHeight);
    _path.quadraticBezierTo(size.width * 0.6 + _arcSize, holeHeight, size.width * 0.6 + _arcSize, holeHeight - _arcSize);
    _path.lineTo(size.width * 0.6 + _arcSize, _arcSize);
    _path.quadraticBezierTo(size.width * 0.6 + _arcSize, 0, size.width * 0.6 + 2 * _arcSize, 0);

    _path.lineTo(size.width - _arcSize, 0);
    _path.quadraticBezierTo(size.width, 0, size.width, _arcSize);
    _path.lineTo(size.width, size.height - _arcSize);


    _path.quadraticBezierTo(size.width, size.height, size.width - _arcSize, size.height);
    _path.lineTo(_arcSize, size.height);
    _path.quadraticBezierTo(0, size.height, 0, size.height - _arcSize);
    _path.lineTo(0, _arcSize);
    _path.close();
    canvas.drawPath(_path, paintBgrCurve);
    // debugPrint('size: ${size.height}  hole: ${size.height - holeHeight}');
  }

  @override
  bool shouldRepaint(BottomNavPainter oldDelegate) => false;
}
