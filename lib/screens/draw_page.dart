import 'package:flutter/material.dart';
import 'dart:math';
import 'package:least_squares/elements/graph_painter.dart';
import 'package:least_squares/models/approximation_model.dart';
import 'package:least_squares/models/graphic_data.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawPage extends StatefulWidget {
  bool _drawGrid = false;
  String _loc;
  GraphicData _graphicData = GraphicData();
  final int _gridCount = 10;

  Map<int, ApproximationModel> _appMap;
  DrawPage(){
    _appMap = Map();
  }

  @override
  _DrawPageState createState() => _DrawPageState();

}

class _DrawPageState extends State<DrawPage>{

  Map<String, List<double>> _allValues;
  int _approximationType = 0;
  double _maxSize, _dotsPerGrid, _a, _b;
  final double _sizeMultiplier = 0.95;

  @override
  void initState() {
    super.initState();
    widget._drawGrid = Provider.of<DataProvider>(context, listen: false).getGridShow();
    _a = Provider.of<DataProvider>(context, listen: false).getAValue();
    _b = Provider.of<DataProvider>(context, listen: false).getBValue();
    widget._graphicData.gridCount = widget._drawGrid ? widget._gridCount : 0;
    widget._graphicData.dataDots = [];
    widget._graphicData.trendDots = [];
    widget._graphicData.displaceY = 0;
    widget._graphicData.displaceX = 0;
    widget._appMap[0] = ApproximationModel(approximationFunction: _approximationLinear, index: 0, name: 'linear');
    widget._appMap[1] = ApproximationModel(approximationFunction: _approximationParabolic, index: 1, name: 'parabolic');
    widget._appMap[2] = ApproximationModel(approximationFunction: _approximationExponential, index: 2, name: 'exponential');
    widget._appMap[3] = ApproximationModel(approximationFunction: _approximationPow, index: 3, name: 'pow');
    widget._appMap[4] = ApproximationModel(approximationFunction: _approximationHyperbolic, index: 4, name: 'hyperbolic');
    widget._appMap[5] = ApproximationModel(approximationFunction: _approximationLog, index: 5, name: 'log');

  }

  @override
  Widget build(BuildContext context){
    int _len = Provider.of<DataProvider>(context).getValuesLength();
    widget._loc = Provider.of<DataProvider>(context).getLocale();

    _maxSize = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    widget._graphicData.maxSize = _maxSize * _sizeMultiplier;
    _dotsPerGrid = widget._graphicData.maxSize / widget._gridCount;
    _allValues = Provider.of<DataProvider>(context).getAllValues();
    widget._graphicData.zoomFactor = _getZoom(_getMaximumDisplace(), widget._gridCount ~/ 2);
    widget._graphicData.dataDots = _fillDataPoints(_allValues['x'], _allValues['y']);
    widget._graphicData.trendDots = widget._appMap[_approximationType].approximationFunction(_allValues['x'], _allValues['y']);


    return Column(
      children: [
        SizedBox(
          width: _maxSize * _sizeMultiplier,
          height: _maxSize * _sizeMultiplier,
          child: CustomPaint(
            size: Size(_maxSize, _maxSize),
            painter: DrawPainter(widget._graphicData),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(8.0),
          child: _len == 0 ?
          Text(MyTranslations().getLocale(widget._loc, 'nanData')) :
          Container(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                value: widget._drawGrid,
                onChanged: (value) {
                  // print('chane checkBox value to $value');
                  Provider.of<DataProvider>(context, listen: false).setGridShow(value);
                  widget._graphicData.gridCount = value ? widget._gridCount : 0;
                  setState(() {
                    widget._drawGrid = value;
                  });
                },
              ),
              Text(MyTranslations().getLocale(widget._loc, 'show_grid')),
            ],
          ),
        ),
      ],
    );
  }

  int _getZoom(double distance, int gridCount){
    int _res = 1, _multiplier = 1;
    if(distance > 1) {
      _multiplier = -1;
      _res = 0;
    }
    while (distance > gridCount || distance < 0){
      _multiplier > 0 ? distance *= gridCount : distance /= gridCount;
      _res += _multiplier;
    }
    return _res;
  }

  double _getMaximumDisplace(){
    double _res = 0.0;
    _allValues.forEach((key, value) {
      for(int i = 0; i < value.length; i++)
        if(value[i].abs() > _res)
          _res = value[i].abs();
    });
    return _res;
  }

  List<Offset> _fillDataPoints(List<double> xValues, List<double> yValues){
    List<Offset> _result = [];
    double _x, _y;
    for(int i = 0; i < xValues.length; i++) {
      _x = _allValues['x'][i] * pow(widget._gridCount, widget._graphicData.zoomFactor) * _dotsPerGrid + widget._graphicData.maxSize/2;
      _y = widget._graphicData.maxSize/2 - _allValues['y'][i] * pow(widget._gridCount, widget._graphicData.zoomFactor) * _dotsPerGrid;
      _result.add(Offset(_x, _y));
    }
    return _result;
  }

  ///approximation functions
  Offset _scaleOffset(Offset source){
    print('before scale x=${source.dx}; y=${source.dy}');
    double _x, _y;
    _x = widget._graphicData.maxSize / 2 + source.dx* pow(widget._gridCount, widget._graphicData.zoomFactor) * _dotsPerGrid + widget._graphicData.displaceX;
    _y = widget._graphicData.maxSize/2 - source.dy* pow(widget._gridCount, widget._graphicData.zoomFactor) * _dotsPerGrid + widget._graphicData.displaceY;
    print('after scale x=$_x; y=$_y');
    return Offset(_x, _y);
  }
  List<Offset> _approximationLinear(List<double> xValues, List<double> yValues){
    double _x, _y;
    _x = - widget._gridCount / 2;
    _y = _b * _x + _a;
    List<Offset> _result = [];
    _result.add(_scaleOffset(Offset(_x, _y)));
    _x = widget._gridCount / 2;
    _y = _b * _x + _a;
    _result.add(_scaleOffset(Offset(_x, _y)));
    return _result;
  }
  List<Offset> _approximationParabolic(List<double> xValues, List<double> yValues){
    List<Offset> _result = [];
    return _result;
  }
  List<Offset> _approximationExponential(List<double> xValues, List<double> yValues){
    List<Offset> _result = [];
    return _result;
  }
  List<Offset> _approximationPow(List<double> xValues, List<double> yValues){
    List<Offset> _result = [];
    return _result;
  }
  List<Offset> _approximationHyperbolic(List<double> xValues, List<double> yValues){
    List<Offset> _result = [];
    return _result;
  }
  List<Offset> _approximationLog(List<double> xValues, List<double> yValues){
    List<Offset> _result = [];
    return _result;
  }
}