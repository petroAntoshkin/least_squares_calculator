import 'package:flutter/material.dart';
import 'package:least_squares/elements/drop_down_list.dart';
import 'dart:math';
import 'package:least_squares/elements/graph_painter.dart';
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

  Map<int, String> _appMap;

  DrawPage() {
    _appMap = Map();
  }

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  Map<String, List<double>> _allValues;
  int _approximationType = 0;
  double _maxSize, _dotsPerGrid, _a, _b;
  final double _sizeMultiplier = 0.95;
  final double _mainLineOffset = 14.0;
  double _divider;

  @override
  void initState() {
    super.initState();
    widget._drawGrid =
        Provider.of<DataProvider>(context, listen: false).getGridShow();
    _a = Provider.of<DataProvider>(context, listen: false).getAValue();
    _b = Provider.of<DataProvider>(context, listen: false).getBValue();
    widget._graphicData.gridCount = widget._drawGrid ? widget._gridCount : 0;
    widget._graphicData.dataDots = [];
    widget._graphicData.trendDots = [];
    widget._graphicData.displaceY = 0;
    widget._graphicData.displaceX = 0;
    widget._appMap[0] = 'linear';
    widget._appMap[1] = 'parabolic';
    widget._appMap[2] = 'exponential';
    widget._appMap[3] = 'pow';
    widget._appMap[4] = 'hyperbolic';
    widget._appMap[5] = 'log';
  }

  @override
  Widget build(BuildContext context) {
    int _len = Provider.of<DataProvider>(context).getValuesLength();
    widget._loc = Provider.of<DataProvider>(context).getLocale();

    _maxSize =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;

    widget._graphicData.maxSize = _maxSize * _sizeMultiplier;
    _dotsPerGrid = widget._graphicData.maxSize / widget._gridCount;
    _allValues = Provider.of<DataProvider>(context).getAllValues();
    widget._graphicData.zoomFactor =
        _getZoom(_getMaximumDisplace(), widget._gridCount ~/ 2);
    widget._graphicData.dataDots =
        _fillDataPoints(_allValues['x'], _allValues['y']);
    if (_allValues['x'].isNotEmpty) {
      _divider = widget._graphicData.zoomFactor == 0? 1: pow(widget._gridCount, widget._graphicData.zoomFactor);
      widget._graphicData.trendDots = _approximationDotsCount(_allValues['x'], _allValues['y'], widget._appMap[_approximationType]);
    }

    return Column(
      children: [
        SizedBox(
          width: _maxSize * _sizeMultiplier,
          height: _maxSize * _sizeMultiplier,
          child: _len != 0
              ? CustomPaint(
                  size: Size(_maxSize, _maxSize),
                  painter: DrawPainter(widget._graphicData),
                )
              : Center(
                  child:
                      Text(MyTranslations().getLocale(widget._loc, 'nanData')),
                ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: widget._drawGrid,
                    onChanged: (value) {
                      // print('chane checkBox value to $value');
                      Provider.of<DataProvider>(context, listen: false)
                          .setGridShow(value);
                      widget._graphicData.gridCount =
                          value ? widget._gridCount : 0;
                      setState(() {
                        widget._drawGrid = value;
                      });
                    },
                  ),
                  Text(MyTranslations().getLocale(widget._loc, 'show_grid')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownList(
                  itemsList:  widget._appMap,
                  currentValue: 0,
                  callBack: _changeApproximationType,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _changeApproximationType(int index) {
    print('changeApproximationType to $index');
    setState(() {
      _approximationType = index;
    });
  }

  int _getZoom(double distance, int gridCount) {
    int _res = 1, _multiplier = 1;
    if (distance > 1) {
      _multiplier = -1;
      _res = 0;
    }
    while (distance > gridCount || distance < 0) {
      _multiplier > 0 ? distance *= gridCount : distance /= gridCount;
      _res += _multiplier;
    }
    return _res;
  }

  double _getMaximumDisplace() {
    double _res = 0.0;
    _allValues.forEach((key, value) {
      for (int i = 0; i < value.length; i++)
        if (value[i].abs() > _res) _res = value[i].abs();
    });
    return _res;
  }

  List<Offset> _fillDataPoints(List<double> xValues, List<double> yValues) {
    List<Offset> _result = [];
    double _x, _y;
    for (int i = 0; i < xValues.length; i++) {
      _x = _allValues['x'][i] *
              pow(widget._gridCount, widget._graphicData.zoomFactor) *
              _dotsPerGrid +
          widget._graphicData.maxSize / 2;
      _y = widget._graphicData.maxSize / 2 -
          _allValues['y'][i] *
              pow(widget._gridCount, widget._graphicData.zoomFactor) *
              _dotsPerGrid;
      _result.add(Offset(_x, _y));
    }
    return _result;
  }

  ///approximation functions
  Offset _scaleOffset(Offset source) {
    // print('before scale x=${source.dx}; y=${source.dy}');
    double _x, _y;
    _x = widget._graphicData.maxSize / 2 +
        source.dx *
            pow(widget._gridCount, widget._graphicData.zoomFactor) *
            _dotsPerGrid +
        widget._graphicData.displaceX;
    _y = widget._graphicData.maxSize / 2 -
        source.dy *
            pow(widget._gridCount, widget._graphicData.zoomFactor) *
            _dotsPerGrid +
        widget._graphicData.displaceY;
    // print('after scale x=$_x; y=$_y');
    return Offset(_x, _y);
  }

  List<Offset> _approximationDotsCount(List<double> xValues, List<double> yValues, String countType) {
    List<Offset> _result = [];
    double _y;
    Offset _offset;
    for(double _x = -(widget._gridCount / 2) / _divider; _x <= (widget._gridCount / 2) / _divider; _x+=0.1){
      switch(countType){
        case 'exponential':
          _y = exp(_a) * _b;
          break;
        case 'pow':
          _y = pow(_x, _a) * _b;
          break;
        case 'hyperbolic':
          _y = _a / _x + _b;
          break;
        case 'log':
          _y = _a * log(_x) + _b;
          break;
        default:
          _y = _x * _a + _b;
          break;
      }
      _offset = _scaleOffset(Offset(_x, _y));
      if(_offset.dx > 0 && _offset.dy > 0 && _offset.dx < widget._graphicData.maxSize && _offset.dy < widget._graphicData.maxSize)
        _result.add(_offset);
    }
    return _result;
    /*
    'parabolic';
    widget._appMap[2] = 'exponential';
    widget._appMap[3] = 'pow';
    widget._appMap[4] = 'hyperbolic';
    widget._appMap[5] = 'log';
     */
  }

}
