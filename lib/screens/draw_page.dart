import 'package:flutter/material.dart';
import 'package:least_squares/elements/graph_painter.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:least_squares/my_translations.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawPage extends StatelessWidget{
  String _loc;
  @override
  Widget build(BuildContext context){
    int _len = Provider.of<DataProvider>(context).getValuesLenght();
    _loc = Provider.of<DataProvider>(context).getLocale();
    double  _maxSize = MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).size.width > MediaQuery.of(context).size.height)
      _maxSize = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          width: _maxSize * 0.95,
          height: _maxSize * 0.95,
          child: CustomPaint(
            size: Size(_maxSize, _maxSize),
            painter: DrawPainter(),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(8.0),
          child: _len == 0 ?
          Text(MyTranslations().getLocale(_loc, 'nanData')) :
          Container(),
        ),
      ],
    );
  }
}