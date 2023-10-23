import 'package:flutter/material.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ValueText extends StatelessWidget {
  String text;
  ThemeData _themeData = ThemeData();
  TextStyle style;

  ValueText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    _themeData = Provider.of<DataProvider>(context).theme;
    return Container(
      // padding: EdgeInsets.all(11.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 7.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 17.0,
                color: _themeData.primaryTextTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
