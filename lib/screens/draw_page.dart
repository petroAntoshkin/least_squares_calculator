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
  String _loc;
  GraphicData _graphicData = GraphicData();

  Offset _startGesturePoint;
  Map<int, String> _appMap;

  DrawPage() {
    _appMap = Map();
    _graphicData.dataDots = [];
    _graphicData.trendDots = [];
    _graphicData.displaceY = 0;
    _graphicData.displaceX = 0;
    _appMap[0] = 'linear';
    _appMap[1] = 'parabolic';
    _appMap[2] = 'pow';
    _appMap[3] = 'log';
    // widget._appMap[4] = 'exponential';
    // widget._appMap[5] = 'hyperbolic';
  }

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  bool _drawGrid = false;
  Map<String, List<double>> _allValues;
  int _approximationType = 0;
  double _maxSize, _dotsPerGrid, _a, _b;
  final double _sizeMultiplier = 0.95;
  double _metamorphosisFactor;
  final _displaceNotifier = ValueNotifier<double>(0);
  final int _gridCount = 10;

  // final double _mainLineOffset = 14.0;
  double _divider;

  String dragDirection;
  double _startDXPoint, _startDYPoint, _startDisplaceX, _startDisplaceY;

  ThemeData _themeData;
  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  void initState() {
    super.initState();
    _a = Provider.of<DataProvider>(context, listen: false).getAValue();
    _b = Provider.of<DataProvider>(context, listen: false).getBValue();
  }

  @override
  Widget build(BuildContext context) {
    _drawGrid = Provider.of<DataProvider>(context, listen: false).getGridShow();
    _themeData = Provider.of<DataProvider>(context, listen: false).theme;
    // FocusScopeNode currentFocus = FocusScope.of(context);
    FocusManager.instance.primaryFocus.unfocus();
    int _len = Provider.of<DataProvider>(context).getValuesLength();
    widget._loc = Provider.of<DataProvider>(context).getLocale();
    _approximationType = Provider.of<DataProvider>(context).approximationType;

    _maxSize =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;

    widget._graphicData.maxSize = _maxSize * _sizeMultiplier;
    _dotsPerGrid = widget._graphicData.maxSize / _gridCount;
    _allValues = Provider.of<DataProvider>(context).getAllValues();
    widget._graphicData.zoomFactor =
        _getInitialZoom(_getMaximumDisplace(), _gridCount);
    widget._graphicData.dataDots =
        _fillDataPoints(_allValues['x'], _allValues['y']);
    if (_allValues['x'].isNotEmpty) {
      // if(widget._graphicData.zoomFactor == 0){
      //   _divider = 1.0;
      // } else {
      //   _divider = pow(widget._gridCount, widget._graphicData.zoomFactor).toDouble();
      // }
      _divider = widget._graphicData.zoomFactor == 0
          ? 1.0
          : pow(_gridCount, widget._graphicData.zoomFactor).toDouble();
      // _divider = 1;
      widget._graphicData.trendDots = _approximationDotsCount(
          _allValues['x'], _allValues['y'], widget._appMap[_approximationType]);
      widget._graphicData.gridCount = _drawGrid ? _gridCount : 0;
    }

    return _keyboardIsVisible()
        ? Container()
        : Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: _maxSize * _sizeMultiplier,
                  height: _maxSize * _sizeMultiplier,
                  child: _len != 0
                      ? GestureDetector(
                          onPanStart: _onPanStartHandler,
                          onPanUpdate: _onPanUpdateHandler,
                          child: CustomPaint(
                            size: Size(_maxSize, _maxSize),
                            painter: DrawPainter(
                                repaint: _displaceNotifier,
                                graphicData: widget._graphicData,
                              themeData: _themeData,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(MyTranslations()
                              .getLocale(widget._loc, 'nanData'),
                            style: TextStyle(
                              color: _themeData.primaryTextTheme.bodyText1.color,
                            ),
                          ),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            activeColor: _themeData.primaryColorDark,
                            checkColor: _themeData.accentColor,
                            value: _drawGrid,
                            onChanged: (value) {
                              // print('chane checkBox value to $value');
                              Provider.of<DataProvider>(context, listen: false)
                                  .setGridShow(value);
                              widget._graphicData.gridCount =
                                  value ? _gridCount : 0;
                              setState(() {
                                _drawGrid = value;
                              });
                            },
                          ),
                          Text(MyTranslations()
                              .getLocale(widget._loc, 'show_grid'),
                            style: TextStyle(
                                color: _themeData.primaryTextTheme.bodyText1.color,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropDownList(
                          itemsList: widget._appMap,
                          currentValue: _approximationType,
                          callBack: _changeApproximationType,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  int _getInitialZoom(double distance, int gridCount) {
    // _metamorphosisFactor = distance / (_maxSize / 2);
    int _res = 1, _multiplier = 1;
    if (distance > 1) {
      _multiplier = -1;
      _res = 0;
    }
    while (distance > gridCount / 2 || distance < 0) {
      _multiplier > 0 ? distance *= gridCount : distance /= gridCount;
      _res += _multiplier;
    }
    _metamorphosisFactor = _dotsPerGrid * pow(_gridCount, _res).toDouble();
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
      // _x = _allValues['x'][i] *
      //         pow(widget._gridCount, widget._graphicData.zoomFactor) *
      //         _dotsPerGrid +
      //     widget._graphicData.maxSize / 2;
      // _y = widget._graphicData.maxSize / 2 -
      //     _allValues['y'][i] *
      //         pow(widget._gridCount, widget._graphicData.zoomFactor) *
      //         _dotsPerGrid;
      _x = _allValues['x'][i] * _metamorphosisFactor +
          widget._graphicData.maxSize / 2 +
          widget._graphicData.displaceX;
      _y = widget._graphicData.maxSize / 2 -
          _allValues['y'][i] * _metamorphosisFactor +
          widget._graphicData.displaceY;
      _result.add(Offset(_x, _y));
    }
    return _result;
  }

  Offset _scaleOffset(Offset source) {
    // print('before scale x=${source.dx}; y=${source.dy}');
    double _x, _y;
    // _x = widget._graphicData.maxSize / 2 +
    //     source.dx *
    //         pow(widget._gridCount, widget._graphicData.zoomFactor) *
    //         _dotsPerGrid +
    //     widget._graphicData.displaceX;
    // _y = widget._graphicData.maxSize / 2 -
    //     source.dy *
    //         pow(widget._gridCount, widget._graphicData.zoomFactor) *
    //         _dotsPerGrid +
    //     widget._graphicData.displaceY;
    // print('after scale x=$_x; y=$_y');
    _x = widget._graphicData.maxSize / 2 +
        source.dx * _metamorphosisFactor +
        widget._graphicData.displaceX;
    _y = widget._graphicData.maxSize / 2 -
        source.dy * _metamorphosisFactor +
        widget._graphicData.displaceY;
    return Offset(_x, _y);
  }

  void _onZoomStart() {}

  ///approximation functions
  ///
  void _changeApproximationType(int index) {
    print('changeApproximationType to $index');
    setState(() {
      _approximationType = index;
      Provider.of<DataProvider>(context, listen: false).approximationType =
          index;
    });
  }

  List<Offset> _approximationDotsCount(
      List<double> xValues, List<double> yValues, String countType) {
    List<Offset> _result = [];
    double _y;
    Offset _offset;
    for (double _x = -(_gridCount) / _divider;
        _x <= (_gridCount) / _divider;
        _x += 0.1) {
      switch (countType) {
        case 'parabolic':
          _y = _a * _x * _x + _b * _x;
          break;
        case 'exponential':
          _y = exp(_a) * _b;
          break;
        case 'pow':
          _y = pow(_x, _b) * _a;
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
      if (_offset.dx > 0 &&
          _offset.dy > 0 &&
          _offset.dx < widget._graphicData.maxSize &&
          _offset.dy < widget._graphicData.maxSize) _result.add(_offset);
    }
    return _result;
  }

  /// gesture functions
  ///
  void _onPanStartHandler(DragStartDetails details) {
    this._startDXPoint = details.globalPosition.dx.floorToDouble();
    this._startDYPoint = details.globalPosition.dy.floorToDouble();
    _startDisplaceX = widget._graphicData.displaceX;
    _startDisplaceY = widget._graphicData.displaceY;
  }

  void _onPanUpdateHandler(DragUpdateDetails details) {
    double _tempDisplace = details.globalPosition.dx - this._startDXPoint;
    final _half = widget._graphicData.maxSize / 2;
    if (_tempDisplace + _startDisplaceX <
            _half - widget._graphicData.axisArrowOffset &&
        _tempDisplace + _startDisplaceX >
            -_half + widget._graphicData.axisArrowOffset) {
      setState(() {
        widget._graphicData.displaceX =
            _displaceNotifier.value = _tempDisplace + _startDisplaceX;
      });
    }
    _tempDisplace = details.globalPosition.dy - this._startDYPoint;
    if (_tempDisplace + _startDisplaceY <
            _half - widget._graphicData.axisArrowOffset &&
        _tempDisplace + _startDisplaceY >
            -_half + widget._graphicData.axisArrowOffset) {
      setState(() {
        widget._graphicData.displaceY =
            _displaceNotifier.value = _tempDisplace + _startDisplaceY;
      });
    }
  }
}
