import 'dart:math';
import 'package:flutter/material.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/models/graphic_data.dart';
import 'package:least_squares/utils/string_utils.dart';
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
  double _factorA,
      _factorB,
      // _divider,
      _metamorphosisX,
      _metamorphosisY,
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
  ];
  int _dotTypeIndex = 0;
  int _approximationType = 0;
  int _editIndex = -1;
  String _approximationName = 'linear';
  Map<String, List<double>> _allValues = Map();
  List<Offset> _sourceAproxDots = [];
  final List<String> _replaceWhat = [',', '+'];
  final List<String> _replaceTo = ['.', ''];
  String _language = 'en';

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

  int get editIndex{
    return _editIndex;
  }

  set editIndex(int value){
    _editIndex = value;
  }

  void dataClean() {
    _allValues['x'] = [];
    _allValues['y'] = [];
    _graphicData.dataDots = [];
    _graphicData.trendDots = [];
    _initSum();
  }

  // void clearAllData() {
  //   // print('clearAllData!!!!!!!!!!!!!');
  //   onlyDataClean();
  //   // notifyListeners();
  // }

  String getAllDataString(){
    String _res = '{"data": {';
    _allValues.forEach((key, value) {
      _res += '"' + key + '": [';
      for(int i = 0; i < value.length; i++){
        if(i > 0) _res += ', ';
        _res += '"${value[i]}"';
      }
      _res += '],';
    });
    _res += '}}';
    _res = _res.replaceAll('],}', ']}');
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
    String _x = _replaceLoop(xText.isNotEmpty ? xText : '0'),
        _y = _replaceLoop(yText.isNotEmpty ? yText : '0');

    _x = StringUtils.addLeadNul(_x);
    _y = StringUtils.addLeadNul(_y);

    // print('isfloat x=${isFloat(_x)} is float y=${isFloat(_y)}');
    if (isFloat(_x) && isFloat(_y)) {
      double _xCandidate = double.parse(_x);
      double _yCandidate = double.parse(_y);
      _err = _checkForDuplicate(_xCandidate, _yCandidate);
      if (_err == 0 || _editIndex >= 0) {
        _err = 0;
        if(_editIndex >= 0){
          _allValues['x'][_editIndex] = _xCandidate;
          _allValues['y'][_editIndex] = _yCandidate;
        } else {
          _allValues['x'].add(_xCandidate);
          _allValues['y'].add(_yCandidate);
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
    for (int i = 0; i < _allValues['x'].length; i++) {
      if (_x == _allValues['x'][i]) _res = 1;
      if (_x == _allValues['x'][i] && _y == _allValues['y'][i]) _res = 2;
    }
    return _res;
  }

  void removeOneValue(int index) {
    _allValues['x'].removeAt(index);
    _allValues['y'].removeAt(index);
    _countAB();
    // notifyListeners();
  }

  void _countAB() {
    _initSum();
    int _len = _allValues['x'].length;
    double _sumX = 0, _sumY = 0, _sumXSquare = 0, _sumXY = 0;
    for (int i = 0; i < _len; i++) {
      _sumX += _allValues['x'][i];
      _sumY += _allValues['y'][i];
      _sumXY += _allValues['x'][i] * _allValues['y'][i];
      _sumXSquare += _allValues['x'][i] * _allValues['x'][i];
    }
    _factorB = (_sumY * _sumXSquare - _sumX * _sumXY) /
        (_len * _sumXSquare - _sumX * _sumX);
    _factorA =
        (_len * _sumXY - _sumX * _sumY) / (_len * _sumXSquare - _sumX * _sumX);
    _globalRecalculation();
  }

  String getAString() {
    return _factorA.isNaN ? nanString : 'a = $_factorA';
  }

  String getBString() {
    return _factorB.isNaN ? nanString : 'b = $_factorB';
  }

  double getAValue() {
    return _factorA;
  }

  double getBValue() {
    return _factorB;
  }

  int getValuesLength() {
    return _allValues['x'].length;
  }

  double getValue(String name, int index) {
    return _allValues[name][index];
  }

  Map<String, List<double>> getAllValues() {
    Map<String, List<double>> _res = Map();
    _allValues.forEach((key, value) {
      _res[key] = [];
      for (int i = 0; i < value.length; i++) _res[key].add(value[i]);
    });
    return _res;
  }

  set maxSize(double value) {
    _graphicData.maxSize = value;
    _globalRecalculation();
  }

  String getValueString(String type, int index){
    if(index < 0)
      return '';
    else
      return _allValues[type][index].toString();
  }

  ///graphics calculations

  int _getInitialZoom(double distance, int gridCount) {
    // _metamorphosisFactor = distance / (_graphicData.maxSize / 2);
    int _res = 1, _multiplier = 1;
    if (distance >= 1) {
      _multiplier = -1;
      _res = 0;
    }
    while (distance > gridCount / 2 || distance < 0) {
      _multiplier > 0 ? distance *= gridCount : distance /= gridCount;
      _res += _multiplier;
    }
    // _metamorphosisX =
    //     _pixelsPerPoint * pow(_graphicData.gridCount, _res).toDouble();
    return _res;
  }

  double _getMaxDisplaceByAxis(String axis) {
    double _res = 0.0;
    for (int i = 0; i < _allValues[axis].length; i++)
      if (_allValues[axis][i].abs() > _res) _res = _allValues[axis][i].abs();
    return _res;
  }

  void _fillDataPoints() {
    double _x, _y;
    _graphicData.dataDots = [];
    for (int i = 0; i < _allValues['x'].length; i++) {
      _x = _allValues['x'][i] * _metamorphosisX +
          (_graphicData.maxSize) / 2 +
          _graphicData.displaceX;
      _y = (_graphicData.maxSize) / 2 -
          _allValues['y'][i] * _metamorphosisY +
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
      switch (_approximationName) {
        case 'parabolic':
          _y = _factorA * _x * _x + _factorB * _x;
          break;
        case 'exponential':
          _y = exp(_factorA) * _factorB;
          break;
        case 'pow':
          _y = pow(_x, _factorB) * _factorA;
          break;
        case 'hyperbolic':
          _y = _factorA / _x + _factorB;
          break;
        case 'log':
          _y = _factorA * log(_x) + _factorB;
          break;
        default:
          _y = _x * _factorA + _factorB;
          break;
      }
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

  double get displaceX {
    return _graphicData.displaceX;
  }

  set displaceY(double value) {
    _graphicData.displaceY = value;
    _fillDataPoints();
    _addDisplaceToApprox();
  }

  double get displaceY {
    return _graphicData.displaceY;
  }

  GraphicData get graphicData {
    return _graphicData.cloneData();
  }

  double get dotSize {
    return _graphicData.dotSize;
  }

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
