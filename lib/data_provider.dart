import 'package:flutter/material.dart';
import 'package:least_squares/localization.dart';
import 'package:least_squares/utils/string_utils.dart';

class DataProvider extends ChangeNotifier{
  List<double> _xValues;
  List<double> _yValues;

  double _a, _b;

  String _nanString;
  String _locName = 'en';

  void initData(String locale){
    _locName = locale;
    _nanString = _nanString = MyLocalization().getLocale(_locName, 'nanMessage');
    _xValues = [];
    _yValues = [];
    _initSum();
  }

  String getLocale(){
    return _locName;
  }
  void setLocale(String loc){
    _locName = loc;
    notifyListeners();
  }

  void _initSum() {
    _a = _b = /*_currentX = _currentY =*/ 0;
  }

  bool addMoreValues(String xText, String yText) {
    double _resX, _resY;
    bool _err = false;
    try {
      _resX = double.parse(StringUtils.normalizeDouble(xText));
      _resY = double.parse(StringUtils.normalizeDouble(yText));
    } catch (e) {
      _err = true;
    }
    if (!_err) {
      _xValues.add(_resX);
      _yValues.add(_resY);
      // _clearControllers();
      _countAB();
    }
    notifyListeners();

    return _err;
  }

  void removeOneValue(int index) {
    _xValues.removeAt(index);
    _yValues.removeAt(index);
    notifyListeners();
  }

  void _countAB() {
    _initSum();
    double _sumX = 0, _sumY = 0, _sumXSquare = 0, _sumXY = 0;
    for (int i = 0; i < _xValues.length; i++) {
      _sumX += _xValues[i];
      _sumY += _yValues[i];
      _sumXY += _xValues[i] + _yValues[i];
      _sumXSquare += _xValues[i] * _xValues[i];
    }
    _a = (_sumY * _sumXSquare - _sumX * _sumXY) /
        ((_xValues.length - 1) * _sumXSquare - _sumX * _sumX);
    _b = ((_xValues.length - 1) * _sumXY - _sumX * _sumY) /
        ((_xValues.length - 1) * _sumXSquare - _sumX * _sumX);
  }

  String getA(){
    return _a.isNaN ? _nanString : 'A = $_a';
  }
  String getB(){
    return _b.isNaN ? _nanString : 'B = $_b';
  }

  int getValuesLenght(){
    return _xValues.length;
  }

  double getValueX(int index){
    return _xValues[index];
  }
  double getValueY(int index){
    return _yValues[index];
  }

}