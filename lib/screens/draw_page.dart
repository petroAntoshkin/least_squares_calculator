import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'package:least_squares/elements/drop_down_list.dart';
import 'package:least_squares/elements/graph_painter.dart';
import 'package:least_squares/elements/list_widgets/approx_linear.dart';
import 'package:least_squares/elements/list_widgets/approx_log.dart';
import 'package:least_squares/elements/list_widgets/approx_parabolic.dart';
import 'package:least_squares/elements/list_widgets/approx_pow.dart';
import 'package:least_squares/elements/list_widgets/dot_circle.dart';
import 'package:least_squares/elements/list_widgets/dot_rhomb.dart';
import 'package:least_squares/elements/list_widgets/dot_square.dart';
import 'package:least_squares/models/graphic_data.dart';
import 'package:least_squares/models/named_widget.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:least_squares/mocks/my_translations.dart';

// ignore: must_be_immutable
class DrawPage extends StatefulWidget {
  String _loc;
  GraphicData _graphicData = GraphicData();

  // Offset _startGesturePoint;
  Map<int, NamedWidget> _approxMap;
  Map<int, NamedWidget> _dotsMap;

  DrawPage() {
    _approxMap = Map();
    _dotsMap = Map();
    _graphicData.dataDots = [];
    _graphicData.trendDots = [];
    _graphicData.displaceY = 0;
    _graphicData.displaceX = 0;
    _approxMap[0] = NamedWidget(name: 'linear', widget: ApproxLinear());
    _approxMap[1] = NamedWidget(name: 'parabolic', widget: ApproxParabolic());
    _approxMap[2] = NamedWidget(name: 'pow', widget: ApproxPow());
    _approxMap[3] = NamedWidget(name: 'log', widget: ApproxLog());
    // widget._appMap[4] = 'exponential';
    // widget._appMap[5] = 'hyperbolic';
    _dotsMap[0] = NamedWidget(name: 'circle', widget: DotCircle());
    _dotsMap[1] = NamedWidget(name: 'square', widget: DotSquare());
    _dotsMap[2] = NamedWidget(name: 'rhomb', widget: DotRhomb());
  }

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  bool _drawGrid = false;
  Map<String, List<double>> _allValues;
  int _approximationType = 0;
  int _dotType = 0;
  double _maxSize, _dotsPerGrid, _a, _b;
  final double _sizeMultiplier = 0.95;
  double _metamorphosisFactor;
  final _displaceNotifier = ValueNotifier<double>(0);
  final int _gridCount = 10;

  // final double _mainLineOffset = 14.0;
  double _divider;

  String dragDirection;
  double _startDXPoint,
      _startDYPoint,
      _startDisplaceX,
      _startDisplaceY,
      _startMetamorphFactor;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      _divider = widget._graphicData.zoomFactor == 0
          ? 1.0
          : pow(_gridCount, widget._graphicData.zoomFactor).toDouble();
      // _divider = 1;
      widget._graphicData.trendDots = _approximationDotsCount(
          _allValues['x'], _allValues['y'], widget._approxMap[_approximationType].name);
      widget._graphicData.gridCount = _drawGrid ? _gridCount : 0;
      widget._graphicData.dotType = widget._dotsMap[_dotType].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._graphicData.maxSize = _maxSize * _sizeMultiplier;
    _drawGrid = Provider.of<DataProvider>(context, listen: false).getGridShow();
    _themeData = Provider.of<DataProvider>(context, listen: false).theme;
    FocusManager.instance.primaryFocus.unfocus();
    int _len = Provider.of<DataProvider>(context).getValuesLength();
    widget._loc = Provider.of<DataProvider>(context).getLocale();
    _approximationType = Provider.of<DataProvider>(context).approximationType;
    _dotType = Provider.of<DataProvider>(context).dotType;
    widget._graphicData.dataDots =
        _fillDataPoints(_allValues['x'], _allValues['y']);
    widget._graphicData.trendDots = _approximationDotsCount(
        _allValues['x'], _allValues['y'], widget._approxMap[_approximationType].name);
    widget._graphicData.gridCount = _drawGrid ? _gridCount : 0;
    widget._graphicData.dotType = widget._dotsMap[_dotType].name;

    return _keyboardIsVisible()
        ? Container()
        : Column(
      children: [
        SizedBox(
          width: _maxSize * _sizeMultiplier,
          height: _maxSize * _sizeMultiplier,
          child: _len != 0
              ? GestureDetector(
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
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
            child: Text(
              MyTranslations().getLocale(widget._loc, 'nanData'),
              style: TextStyle(
                color:
                _themeData.primaryTextTheme.bodyText1.color,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 26.0,
          child: Slider(
              value: widget._graphicData.dotSize,
              min: 3.0,
              max: 15.0,
              divisions: 28,
              onChanged: (value) => setState((){
                widget._graphicData.dotSize = value;
              }),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
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
                  Text(
                    MyTranslations()
                        .getLocale(widget._loc, 'show_grid'),
                    style: TextStyle(
                      color:
                      _themeData.primaryTextTheme.bodyText1.color,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownList(
                  itemsList: widget._approxMap,
                  currentValue: _approximationType,
                  callBack: _changeApproximationType,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownList(
                  itemsList: widget._dotsMap,
                  currentValue: _dotType,
                  callBack: _changeDotType,
                ),
              ),
            ],
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
      _x = _allValues['x'][i] * _metamorphosisFactor +
          (_maxSize * _sizeMultiplier) / 2 +
          widget._graphicData.displaceX;
      _y = (_maxSize * _sizeMultiplier) / 2 -
          _allValues['y'][i] * _metamorphosisFactor +
          widget._graphicData.displaceY;
      _result.add(Offset(_x, _y));
    }
    return _result;
  }

  Offset _scaleOffset(Offset source) {
    // print('before scale x=${source.dx}; y=${source.dy}');
    double _x, _y;
    _x = (_maxSize * _sizeMultiplier) / 2 +
        source.dx * _metamorphosisFactor +
        widget._graphicData.displaceX;
    _y = (_maxSize * _sizeMultiplier) / 2 -
        source.dy * _metamorphosisFactor +
        widget._graphicData.displaceY;
    return Offset(_x, _y);
  }

  void _changeDotType(int index) {
    //print('changeApproximationType to $index');
    setState(() {
      _dotType = index;
      widget._graphicData.dotType = widget._dotsMap[_dotType].name;
      Provider.of<DataProvider>(context, listen: false).dotType =
          index;
    });
  }

  ///approximation functions
  ///
  void _changeApproximationType(int index) {
    //print('changeApproximationType to $index');
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
  void _onScaleStart(ScaleStartDetails scaleStartDetails) {
    this._startDXPoint = scaleStartDetails.focalPoint.dx.floorToDouble();
    this._startDYPoint = scaleStartDetails.focalPoint.dy.floorToDouble();
    _startDisplaceX = widget._graphicData.displaceX;
    _startDisplaceY = widget._graphicData.displaceY;
    _startMetamorphFactor = _metamorphosisFactor;
  }

  void _onScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    double _tempDisplace =
        scaleUpdateDetails.focalPoint.dx - this._startDXPoint;
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
    _tempDisplace = scaleUpdateDetails.focalPoint.dy - this._startDYPoint;
    if (_tempDisplace + _startDisplaceY <
        _half - widget._graphicData.axisArrowOffset &&
        _tempDisplace + _startDisplaceY >
            -_half + widget._graphicData.axisArrowOffset) {
      setState(() {
        widget._graphicData.displaceY =
            _displaceNotifier.value = _tempDisplace + _startDisplaceY;
      });
    }
    //print('scale before: $_metamorphosisFactor');
    if (scaleUpdateDetails.scale != 1.0)
      _metamorphosisFactor = _startMetamorphFactor * scaleUpdateDetails.scale;
    //print('scale after: $_metamorphosisFactor');
  }
}
