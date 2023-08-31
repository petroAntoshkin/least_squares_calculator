import 'package:flutter/material.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';

// ignore: must_be_immutable
class DotSquare extends StatelessWidget {
  Color color;
  DotSquare({this.color = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: Presets.LINE_WIDTH,
        height: Presets.DOT_SIZE,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 1.0,
                width: Presets.LINE_WIDTH,
                child: Container(
                  color: Colors.green,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: Presets.DOT_SIZE,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
