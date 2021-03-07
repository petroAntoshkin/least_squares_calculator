import 'dart:io';

import 'package:flutter/material.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/models/settings_model.dart';
import 'package:least_squares/utils/string_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:validators/validators.dart';

class DataProvider extends ChangeNotifier{
  Map<String, List<double>> _allValues;
  final String _settingsJson = '/settings.json';
  final List<String> _replaceWhat = [',', '+'];
  final List<String> _replaceTo = ['.', ''];
  int approximationType = 0;


  double _a, _b;

  String _nanString;
  // String _locName = 'en';
  // String _theme = 'default';
  SettingsModel _settingsModel = SettingsModel(language: 'en', theme: 'default', showGrid: true);

  DataProvider(){
    _nanString = _nanString = MyTranslations().getLocale(_settingsModel.language, 'nanMessage');
    _allValues = new Map();
    _onlyDataClean();
    _readSettingsData();
  }
  ///       settings section
  String getLocale(){
    return _settingsModel.language;
  }

  void applySettings(SettingsModel settings){
    _setLocale(settings.language);
    notifyListeners();
  }

  void changeLocale(String loc){
    if(loc != _settingsModel.language) {
      _settingsModel.language = loc;
      writeLocalJson();
      notifyListeners();
    }
  }

  void _setLocale(String loc){
    _settingsModel.language = loc;
    // notifyListeners();
  }

  void changeTheme(String theme){
    if(theme != _settingsModel.theme) {
      _setTheme(theme);
      writeLocalJson();
      notifyListeners();
    }
  }

  void _setTheme(String theme){
    _settingsModel.theme = theme;
    // notifyListeners();
  }

  void setGridShow(bool value){
    _settingsModel.showGrid = value;
  }

  bool getGridShow(){
    return _settingsModel.showGrid;
  }

  ///       data section

  void _initSum() {
    _a = _b = 0;
  }
  void _onlyDataClean() {
    _allValues['x'] = [];
    _allValues['y'] = [];
    _initSum();
  }

  void clearAllData(){
    // print('clearAllData!!!!!!!!!!!!!');
    _onlyDataClean();
    notifyListeners();
  }

  String _replaceLoop(String source){
    String _res = source;
    for(int i = 0; i < _replaceWhat.length; i++){
      _res = StringUtils.replaceOneSymbol(_res, _replaceWhat[i], _replaceTo[i]);
    }
    return _res;
  }

  bool addMoreValues(String xText, String yText) {
    bool _err = true;
    String _x = _replaceLoop(xText.isNotEmpty ? xText: '0'),
        _y = _replaceLoop(yText.isNotEmpty ? yText : '0');

    _x = StringUtils.addLeadNul(_x);
    _y = StringUtils.addLeadNul(_y);

    // print('isfloat x=${isFloat(_x)} is float y=${isFloat(_y)}');
    if(isFloat(_x) && isFloat(_y)) {
      _allValues['x'].add(double.parse(_x));
      _allValues['y'].add(double.parse(_y));
      _countAB();
      _err = false;
      notifyListeners();
    }
    return _err;
  }

  void removeOneValue(int index) {
    _allValues['x'].removeAt(index);
    _allValues['y'].removeAt(index);
    notifyListeners();
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
    _b = (_sumY * _sumXSquare - _sumX * _sumXY) /
        (_len * _sumXSquare - _sumX * _sumX);
    _a = (_len * _sumXY - _sumX * _sumY) /
        (_len * _sumXSquare - _sumX * _sumX);
  }

  String getAString(){
    return _a.isNaN ? _nanString : 'a = $_a';
  }

  String getBString(){
    return _b.isNaN ? _nanString : 'b = $_b';
  }

  double getAValue(){
    return _a;
  }
  double getBValue(){
    return _b;
  }

  int getValuesLength(){
    return _allValues['x'].length;
  }

  double getValue(String name, int index){
    return _allValues[name][index];
  }

  Map<String, List<double>> getAllValues(){
    Map<String, List<double>> _res = Map();
    _allValues.forEach((key, value) {
      _res[key] = [];
      for(int i = 0; i < value.length; i++)
        _res[key].add(value[i]);
    });
    return _res;
  }

  /// read/write section
  Future<File> writeLocalJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}$_settingsJson');

    // String json = jsonEncode(mainDataToWrite);//Utils.correctJson(mainDataToWrite.toString());
    // print('---------------------local path: $localPath');
    // Write the file
    return file.writeAsString(_settingsModel.toString());
  }


  Future<void> _readSettingsData() async {
    SettingsModel _result = new SettingsModel();
    // print('call settings provider read data');
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}$_settingsJson');

      // Read the file
      String contents = await file.readAsString();
      // var _dec = json.decode(contents);
      _result.parseJson(contents);
      changeTheme(_result.theme);
      changeLocale(_result.language);
    } catch (e) {
      // If encountering an error, return 0
      print('catch $e');
    }
  }

}