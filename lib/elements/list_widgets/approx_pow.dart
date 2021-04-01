import 'package:flutter/material.dart';
import 'package:least_squares/styles_and_presets.dart';

// ignore: must_be_immutable
class ApproxPow extends StatelessWidget {
  Color color;
  ApproxPow({this.color : Colors.black});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'x',
          style: TextStyle(
            color: color,
            fontStyle: FontStyle.italic,
            fontSize: Presets.TEXT_SIZE_DEFAULT,
          ),
        ),
        Text(
          'ᵇ',
          style: TextStyle(
            color: color,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: Presets.TEXT_SIZE_DEFAULT * 1.1,
          ),
        ),
        Text(
          ' · ',
          style: TextStyle(
            color: color,
            fontStyle: FontStyle.italic,
            fontSize: Presets.TEXT_SIZE_DEFAULT,
          ),
        ),
        Text(
          'a',
          style: TextStyle(
            color: color,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: Presets.TEXT_SIZE_DEFAULT * 1.1,
          ),
        ),
      ],
    );
  }
}
