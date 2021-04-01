import 'package:flutter/material.dart';

class BottomNavPainter extends CustomPainter {

  Color color;

  BottomNavPainter({this.color});

  final _tumbWidth = 0.17;
  final _arcSize = 8.0;

  void paint(Canvas canvas, Size size) {

    final Path _path = new Path();
    final paintBgrCurve = Paint()
      ..style = PaintingStyle.stroke
      ..color = color//Color(0x55ff0000)
      ..strokeWidth = 1;

    // _path.moveTo(0, 0);
    _path.moveTo(size.width, 0);
    _path.lineTo(size.width - size.width * _tumbWidth + _arcSize, 0);
    //_path.lineTo(size.width, size.height);
    _path.quadraticBezierTo(size.width - size.width * _tumbWidth, 0,
        size.width - size.width * _tumbWidth, _arcSize);
    // _path.lineTo(size.width - size.width * _tumbWidth, size.height);
    _path.lineTo(size.width - size.width * _tumbWidth, size.height * 0.5 - _arcSize);
    _path.quadraticBezierTo(size.width - size.width * _tumbWidth, size.height * 0.5,
        size.width - size.width * _tumbWidth - _arcSize, size.height * 0.5);
    _path.lineTo(size.width * _tumbWidth + _arcSize, size.height * 0.5);
    _path.quadraticBezierTo(size.width * _tumbWidth, size.height * 0.5,
      size.width * _tumbWidth, size.height * 0.5 + _arcSize);
    _path.lineTo(size.width * _tumbWidth, size.height - _arcSize);
    _path.quadraticBezierTo(size.width * _tumbWidth, size.height,
        size.width * _tumbWidth - _arcSize, size.height);
    // _path.lineTo(0, size.height);
    // _path.close();
    canvas.drawPath(_path, paintBgrCurve);
  }

  @override
  bool shouldRepaint(BottomNavPainter oldDelegate) => false;
}
