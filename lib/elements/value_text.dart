import 'package:flutter/material.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ValueText extends StatelessWidget{
  String text;
  ThemeData _themeData;
  TextStyle style;
  ValueText({@required this.text, this.style});
  @override
  Widget build(BuildContext context){
    _themeData = Provider.of<DataProvider>(context).theme;
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Card(
          color: _themeData.primaryColorDark,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(text, style: TextStyle(
                    color: _themeData.accentColor,
                  ))
            ),
          )),
    );
  }
}