import 'dart:math';

import 'package:flutter/material.dart';
import 'package:least_squares_calculator/models/axis_label_model.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AxisLabel extends StatelessWidget {
  late ThemeData _themeData;

  late AxisLabelModel labelModel;
  String label;
  String direction;
  double _rotation = 0, _displaceX = 0.0, _displaceY = 0.0;
  final _width = 50.0;
  final _height = 20.0;

  AxisLabel({required this.label, required this.direction});

  @override
  Widget build(BuildContext context) {
    _themeData = Provider.of<DataProvider>(context, listen: false).theme;
    labelModel = Provider.of<DataProvider>(context).getAxisModel(label);
    _rotation = -(pi / 2) * labelModel.rotationTimes;

    if(label == 'x'){
      _displaceX = 0;
      if(labelModel.flipped)
        _displaceY = -1.5 * _height;
      else
        _displaceY = 0.5 * _height;
    } else {
      if(labelModel.rotationTimes == 0) {
        _displaceY = 0;
        if (labelModel.flipped)
          _displaceX = -1.2 * _width;
        else
          _displaceX =  0.2 * _width;
      } else{
        _displaceX = -0.4 * _width;
        if (labelModel.flipped)
          _displaceY = -2 * _height;
        else
          _displaceY =  0.2 * _height;
      }
    }
    Matrix4 _myMatrix = Matrix4(
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1,
    );
    _myMatrix.rotateZ(_rotation);
    _myMatrix.translate(_displaceX, _displaceY);
    return labelModel.visibility
        ? SizedBox(
            width: _width,
            height: _height,
            child: Transform(
              alignment: Alignment.center,
              transform: _myMatrix,
              child: Container(
                padding: EdgeInsets.all(2.0),
                color: _themeData.backgroundColor,
                child: FittedBox(
                  child: Text(
                    labelModel.text,
                    style: TextStyle(
                      color: _themeData.indicatorColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
