import 'dart:math';
import 'package:flutter/material.dart';
import 'package:least_squares_calculator/mocks/my_translations.dart';
import 'package:least_squares_calculator/models/graphic_data.dart';
import 'package:least_squares_calculator/models/point_model.dart';
import 'package:least_squares_calculator/models/pow_model.dart';
import 'package:least_squares_calculator/utils/string_utils.dart';
import 'package:validators/validators.dart';

mixin CalculateMixin {
  final GraphicData _graphicData = GraphicData(
    gridCount: 10,
    dataDots: [],
    trendDots: [],
    showGrid: true,
    displaceX: 0.0,
    displaceY: 0.0,
    maxSize: 200.0,
    zoomFactorX: 1,
    zoomFactorY: 1,
  );
  double _factorA = .0,
      _factorB = .0,
      _deviationA = .0,
      _deviationB = .0,
      // _divider,
      _metamorphosisX = 1.0,
      _metamorphosisY = 1.0,
      // _sizeMultiplier,
      _pixelsPerPoint = 30.0;
  final _approxNames = [
    'linear',
    'parabolic',
    'pow',
    'log',
  ];
  final _dotTypes = [
    'circle',
    'square',
    'rhomb',
    'crest',
  ];
  final Map<String, int> powMap = {
    'x': 0,
    'y': 0,
  };
  final powMaximum = 10;

  int _dotTypeIndex = 0;
  int _approximationType = 0;
  int _editIndex = -1;
  String _approximationName = 'linear';
  Map<String, List<double>> _allValues = Map();
  List<PointModel> _dataList = [];
  List<Offset> _sourceAproxDots = [];
  final List<String> _replaceWhat = [',', '+'];
  final List<String> _replaceTo = ['.', ''];
  String _language = 'en', currentXValue = '', currentYValue = '';

  String get nanString {
    return MyTranslations().getLocale(_language, 'nanMessage');
  }

  set mixinLanguage(String lan) {
    _language = lan;
  }

  ///data section
  void _initSum() {
    _factorA = _factorB = 0;
  }

  int get editIndex => _editIndex;

  set editIndex(int value) {
    _editIndex = value;
  }

  bool isDataEdited(int index) => _editIndex == index;

  void dataClean() {
    _dataList = [];
    _graphicData.dataDots = [];
    _graphicData.trendDots = [];
    _initSum();
  }

  int dataLength() => _dataList.length;

  String getAllDataString() {
    String _res = '{"data": {"x": [';
    for(int i = 0; i < _dataList.length; i++){
      if(i > 0) _res += ', ';
      _res += '"${_dataList[i].x}"';
    }
    _res += '], "y": [';
    for(int i = 0; i < _dataList.length; i++){
      if(i > 0) _res += ', ';
      _res += '"${_dataList[i].y}"';
    }
    _res += ']}}';
    return _res;
  }
  String _replaceLoop(String source) {
    String _res = source;
    for (int i = 0; i < _replaceWhat.length; i++) {
      _res = StringUtils.replaceOneSymbol(_res, _replaceWhat[i], _replaceTo[i]);
    }
    return _res;
  }

  int addMoreValues(String xText, String yText) {
    int _err = 0;
    if (xText.isEmpty || yText.isEmpty) {
      return _err;
    }
    String _x = _replaceLoop(xText.isNotEmpty ? xText : '0'),
        _y = _replaceLoop(yText.isNotEmpty ? yText : '0');
    _x = StringUtils.addLeadNul(_x);
    _y = StringUtils.addLeadNul(_y);
    // debugPrint('isfloat x=${isFloat(_x)} is float y=${isFloat(_y)}');
    if (isFloat(_x) && isFloat(_y)) {
      double _xCandidate = double.parse(StringUtils.doubleShift(
          doubleBase: double.parse(_x), powValue: powMap['x']!));
      double _yCandidate = double.parse(StringUtils.doubleShift(
          doubleBase: double.parse(_y), powValue: powMap['y']!));
      _err = _checkForDuplicate(_xCandidate, _yCandidate);
      if (_err == 0) {
        _err = 0;
        if (_editIndex >= 0) {
          _dataList[_editIndex].x = _xCandidate;
          _dataList[_editIndex].y = _yCandidate;
        } else {
          _dataList.add(PointModel(x: _xCandidate, y: _yCandidate));
        }
        _editIndex = -1;
        _countAB();
      }
      // notifyListeners();
    }
    return _err;
  }

  int _checkForDuplicate(double _x, double _y) {
    int _res = 0;
    for (int i = 0; i < _dataList.length; i++) {
      if (_x == _dataList[i].x && _editIndex != i) {
        _res = 1;
        if (_y == _dataList[i].y && _editIndex == i) _res = 2;
        return _res;
      }
    }
    return _res;
  }

  void removeOneValue(int index) {
    _dataList.removeAt(index);
    _countAB();
    // notifyListeners();
  }

  int swapData(int index) {
    final _error = _checkForDuplicate(_dataList[index].x, _dataList[index].y);
    if (_error == 0) {
      final _buffer = _dataList[index].x;
      _dataList[index].x = _dataList[index].y;
      _dataList[index].y = _buffer;
      _countAB();
    }
    return _error;
  }

  void _countAB() {
    _initSum();
    int? _len = _dataList.length;
    double _sumX = 0,
        _sumY = 0,
        _sumXSquare = 0,
        _sumXY = 0,
        _sumFunDif = 0,
        _sumXDif = 0;
    for (int i = 0; i < _len; i++) {
      _sumX += _dataList[i].x;
      _sumY += _dataList[i].y;
      _sumXY += _dataList[i].x * _dataList[i].y;
      _sumXSquare += _dataList[i].x * _dataList[i].x;
    }
    _factorA =
        (_len * _sumXY - _sumX * _sumY) / (_len * _sumXSquare - _sumX * _sumX);
    _factorB = (_sumY * _sumXSquare - _sumX * _sumXY) /
        (_len * _sumXSquare - _sumX * _sumX);
    // _factorB = _sumY - _factorA * _sumX;
    _deviationA = _deviationB = 0;
    final double _xs = _sumX / _len;
    // final double _ys = _sumY / _len;
    for (int i = 0; i < _len; i++) {
      _sumFunDif +=
          (_dataList[i].y - _factorA * _dataList[i].x - _factorB) *
              (_dataList[i].y - _factorA * _dataList[i].x - _factorB);
      _sumXDif += (_dataList[i].x - _xs) * (_dataList[i].x - _xs);
    }
    // debugPrint('sumX=$_sumX xDif=$_sumXDif function dif=$_sumFunDif');
    _deviationA = sqrt(_sumFunDif / ((-2 + _len) * _sumXDif));
    _deviationB =
        sqrt((1 / _len + (_xs * _xs) / _sumXDif) * _sumFunDif / (-2 + _len));
    _globalRecalculation();
  }

  String getAString() => _factorA.isNaN ? nanString : 'a = $_factorA';

  String getADeviationString() =>
      _deviationA.isNaN ? nanString : 'σ₁ = $_deviationA';

  String getBString() => _factorB.isNaN ? nanString : 'b = $_factorB';

  String getBDeviationString() =>
      _deviationB.isNaN ? nanString : 'σ₂ = $_deviationB';

  double getAValue() => _factorA;

  double getADeviation() => _deviationA;

  double getBValue() => _factorB;

  double getBDeviation() => _deviationB;

  int getValuesLength() => _dataList.length;

  double getValue(String name, int index) {
    PowModel val = getValuePowModel(name, index);
    double res = double.parse(StringUtils.doubleShift(
        doubleBase: double.parse(val.base), powValue: val.powIndex));
    return res;
  }

  PowModel getValuePowModel(String flag, int index) {
    if (index == -1) return PowModel();
    final sign = flag == 'x' ? _getSign(_dataList[index].x) : _getSign(_dataList[index].y);
    String _res = flag == 'x' ? _dataList[index].x.abs().toString()
        : _dataList[index].y.abs().toString();
    int _pow = 0;
    List<String> _split =
        flag == 'x' ? _dataList[index].x.toStringAsExponential().split('e')
        : _dataList[index].y.toStringAsExponential().split('e');
    if (int.parse(_split[1]).abs() > 3) {
      _pow = int.parse(_split[1]);
      _res = _split[0];
    }
    return PowModel(base: '$sign$_res', powIndex: _pow);
  }


  set maxSize(double value) {
    _graphicData.maxSize = value;
    _globalRecalculation();
  }

  String _getSign(double value) => value < 0 ? '-' : '';

  String getValueString(String flag, int index) {
    if (index < 0) {
      return '';
    }
    final sign = flag == 'x' ? _getSign(_dataList[index].x) : _getSign(_dataList[index].y);
    double res = flag == 'x' ? _dataList[index].x.abs() : _dataList[index].y.abs();
    powMap[flag] = 0;
    if (res == 0) {
      return '0';
    }
    while (res < 0.1 && powMap[flag]!.abs() < powMaximum) {
      res = double.parse(StringUtils.doubleShift(doubleBase: res, powValue: 1));
      powMap[flag] = powMap[flag]! - 1;
    }
    while ((res / 10 == res ~/ 10 && res / 10 > 0) &&
        powMap[flag]!.abs() < powMaximum) {
      res /= 10;
      // res = double.parse(StringUtils.doubleShift(doubleBase: res, powValue: -1));
      powMap[flag] = powMap[flag]! + 1;
    }
    return '$sign$res';
  }

  bool sortData(){
    if (_dataList.length < 2){
      return false;
    }
    _dataList.sort((PointModel a, PointModel b) => a.x.compareTo(b.x));
    return true;
  }

  ///graphics calculations

  int _getInitialZoom(double distance, int gridCount) {
    if (distance == 0) return 0;
    int _res = 0;
    final _multiplier = distance >= 1 ? -1 : 1;
    if (distance > gridCount / 2) {
      while (distance > gridCount / 2) {
        distance /= gridCount;
        _res += _multiplier;
      }
    } else {
      while (distance < 1) {
        distance *= gridCount;
        _res += _multiplier;
      }
    }
    return _res;
  }

  double _getMaxDisplaceByAxis(String axis) {
    PointModel max = _dataList.reduce((a, b) {
      if (a.x > b.x)
        return a;
      else
        return b;
    }
    );
    return axis == 'x' ? max.x : max.y;
  }

  void _fillDataPoints() {
    double _x, _y;
    _graphicData.dataDots = [];
    for (int i = 0; i < _dataList.length; i++) {
      _x = _dataList[i].x * _metamorphosisX +
          (_graphicData.maxSize) / 2 +
          _graphicData.displaceX;
      _y = (_graphicData.maxSize) / 2 -
          _dataList[i].y * _metamorphosisY +
          _graphicData.displaceY;
      _graphicData.dataDots.add(Offset(_x, _y));
    }
  }

  set dotTypeIndex(int index) {
    _dotTypeIndex = index;
    dotType = _dotTypes[index];
  }

  int get dotTypeIndex {
    return _dotTypeIndex;
  }

  set dotType(String name) {
    _graphicData.dotType = name;
  }

  String get dotType {
    return _graphicData.dotType;
  }

  set gridShow(bool value) {
    _graphicData.showGrid = value;
  }

  get pixelsPerGrid {
    return _pixelsPerPoint;
  }

  ///approximation functions
  ///
  set approximationType(int index) {
    _approximationType = index;
    _approximationName = _approxNames[_approximationType];
    _fillApproximationPoints();
  }

  int get approximationType {
    return _approximationType;
  }

  void _addDisplaceToApprox() {
    _graphicData.trendDots = [];
    for (int i = 0; i < _sourceAproxDots.length; i++) {
      _graphicData.trendDots.add(Offset(
        _sourceAproxDots[i].dx + _graphicData.displaceX,
        _sourceAproxDots[i].dy + _graphicData.displaceY,
      ));
    }
  }

  double _getFunctionValue({required String name, required double x}) {
    double _y;
    switch (name) {
      case 'parabolic':
        _y = _factorA * x * x + _factorB * x;
        break;
      case 'exponential':
        _y = exp(_factorA) * _factorB;
        break;
      case 'pow':
        _y = pow(x, _factorB) * _factorA;
        break;
      case 'hyperbolic':
        _y = _factorA / x + _factorB;
        break;
      case 'log':
        _y = _factorA * log(x) + _factorB;
        break;
      default:
        _y = x * _factorA + _factorB;
        break;
    }
    return _y;
  }

  void _fillApproximationPoints() {
    _sourceAproxDots = [];
    double _y, _start, _end;
    final _countStep = 1 / _metamorphosisX;
    //pow(_graphicData.gridCount, _graphicData.zoomFactorX) / _graphicData.gridCount;
    //_graphicData.gridCount * pow(_graphicData.gridCount, _graphicData.zoomFactor);
    _start = -_graphicData.gridCount /
        pow(_graphicData.gridCount, _graphicData.zoomFactorX).toDouble();
    _end = _graphicData.gridCount /
        pow(_graphicData.gridCount, _graphicData.zoomFactorX).toDouble();
    Offset _offset;
    for (double _x = _start; _x <= _end; _x += _countStep) {
      _y = _getFunctionValue(name: _approximationName, x: _x);
      bool _diff = false;
      _offset = Offset(
          _graphicData.maxSize / 2 +
              _x * _metamorphosisX /* + _graphicData.displaceX*/,
          _graphicData.maxSize / 2 -
              _y * _metamorphosisY /* + _graphicData.displaceY*/);
      if (_sourceAproxDots.isNotEmpty)
        _diff = (_offset.dx - _sourceAproxDots.last.dx).abs() >= 1 ||
            (_offset.dy - _sourceAproxDots.last.dy).abs() >= 1;
      // _offset = _scaleOffset(Offset(_x, _y));
      if (/*_offset.dx > 0 &&
          _offset.dy > 0 &&
          _offset.dx < _graphicData.maxSize &&
          _offset.dy < _graphicData.maxSize &&*/
          !_offset.dx.isNaN &&
              !_offset.dy.isNaN &&
              (_sourceAproxDots.length == 0 || _diff)) {
        // _graphicData.trendDots.add(_offset);
        _sourceAproxDots.add(_offset);
      }
    }
    _addDisplaceToApprox();
  }

  set displaceX(double value) {
    _graphicData.displaceX = value;
    _fillDataPoints();
    _addDisplaceToApprox();
  }

  double get displaceX => _graphicData.displaceX;

  set displaceY(double value) {
    _graphicData.displaceY = value;
    _fillDataPoints();
    _addDisplaceToApprox();
  }

  double get displaceY => _graphicData.displaceY;

  GraphicData get graphicData => _graphicData.cloneData();

  double get dotSize => _graphicData.dotSize;

  set dotSize(double value) {
    _graphicData.dotSize = value;
  }

  void _globalRecalculation() {
    _pixelsPerPoint = _graphicData.maxSize / _graphicData.gridCount;
    _graphicData.zoomFactorX =
        _getInitialZoom(_getMaxDisplaceByAxis('x'), _graphicData.gridCount);
    _graphicData.zoomFactorY =
        _getInitialZoom(_getMaxDisplaceByAxis('y'), _graphicData.gridCount);
    _metamorphosisX = _pixelsPerPoint *
        pow(_graphicData.gridCount, _graphicData.zoomFactorX).toDouble();
    _metamorphosisY = _pixelsPerPoint *
        pow(_graphicData.gridCount, _graphicData.zoomFactorY).toDouble();
    _fillDataPoints();
    if (!_factorA.isNaN && !_factorB.isNaN) _fillApproximationPoints();
  }
}
