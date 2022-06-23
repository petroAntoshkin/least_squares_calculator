import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:least_squares/mixins/calculate_mixin.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/mocks/themes_mock.dart';
import 'package:least_squares/models/axis_label_model.dart';
import 'package:least_squares/models/image_pare.dart';
import 'package:least_squares/models/settings_model.dart';
import 'package:least_squares/models/theme_list_model.dart';
import 'package:least_squares/utils/string_utils.dart';
import 'package:path_provider/path_provider.dart';

class DataProvider extends ChangeNotifier with CalculateMixin {
  List<Function> _contextFunctions = List.generate(4, (index) => null);
  final String _settingsJson = '/settings.json';
  final String _dataJson = '/data_snapshot.json';


  Directory _appDirectory;

  // int dotTypeIndex = 0;
  ThemeData _themeData;
  int _themeID;
  List<ImagePair> _imagesList;
  String _defaultLocale;
  double _bottomNavBarHeight;

  String focusOnText = '';

  // double _factorA, _factorB;

  final Map<String, AxisLabelModel> _labels = Map();

  SettingsModel _settingsModel;

  DataProvider() {
    _defaultLocale = _getDeviceLocale(Platform.localeName);
    _resetSettings();
    _themeData = ThemesMock().themes[_themeID].data;
    _labels['x'] = AxisLabelModel(text: 'X');
    _labels['y'] = AxisLabelModel(text: 'Y');
    _imagesList = [];
    dataClean();
    _readSettingsData();
    _readSavedData();
    _contextFunctions[3] = _resetSettings;
    //print('${Platform.localeName} def loacale is $_defaultLocale');
  }

  ///bottom navBar
  // ignore: unnecessary_getters_setters
  get navBarHe {
    return _bottomNavBarHeight;
  }

  // ignore: unnecessary_getters_setters
  set navBarHe(double value) {
    _bottomNavBarHeight = value;
  }

  ///locale from device
  String _getDeviceLocale(String so) {
    String _firstLet = so.substring(0, 2);
    if (!MyTranslations().isLanguageAvailable(_firstLet)) _firstLet = 'en';
    return _firstLet;
  }

  ///labels section
  AxisLabelModel getAxisModel(String axis) {
    return _labels[axis];
  }

  void changeLabelVis(String axis, bool visibility) {
    _labels[axis].visibility = visibility;
    notifyListeners();
  }

  void changeLabelsText(String xText, String yText) {
    _labels['x'].text = xText;
    _labels['y'].text = yText;
    notifyListeners();
  }

  void changeLabelRotation(String axis) {
    _labels[axis].rotationTimes++;
    if (_labels[axis].rotationTimes > 1) _labels[axis].rotationTimes = 0;
    notifyListeners();
  }

  void changeLabelFlip(String axis, bool flip) {
    _labels[axis].flipped = flip;
    notifyListeners();
  }

  ///       settings section
  void _resetSettings() {
    _themeID = 0;
    _settingsModel = SettingsModel(
        language: _defaultLocale, themeId: _themeID, showGrid: true);
    _setTheme(_themeID);
    notifyListeners();
  }

  String getLanguage() {
    return _settingsModel.language;
  }

  void applySettings(SettingsModel settings) {
    _setLocale(settings.language);
    notifyListeners();
  }

  void changeLocale(String loc) {
    mixinLanguage = loc;
    if (loc != _settingsModel.language) {
      _settingsModel.language = loc;
      _saveSettings();
      notifyListeners();
    }
  }

  void _setLocale(String loc) {
    _settingsModel.language = loc;
    // notifyListeners();
  }

  ///theme functions
  void changeTheme(int themeId) {
    if (themeId != _settingsModel.themeId) {
      _setTheme(themeId);
      _saveSettings();
      notifyListeners();
    }
  }

  void _setTheme(int id) {
    _themeID = id;
    _themeData = ThemesMock().themes[_themeID].data;
    _settingsModel.themeId = _themeID;
    // notifyListeners();
  }

  int get themeId {
    return _themeID;
  }

  get theme {
    return _themeData;
  }

  ThemeListModel getThemeModelById(int index) {
    return ThemesMock().themes[index];
  }

  ///   grid

  void setGridShow(bool value) {
    _settingsModel.showGrid = gridShow = value;
  }

  void changeGridShow(bool value) {
    _settingsModel.showGrid = value;
    gridShow = value;
    notifyListeners();
    _saveSettings();
  }

  bool getGridShow() {
    return _settingsModel.showGrid;
  }

  ///       data section

  int dataLength() => super.dataLength();

  void _restoreData(var data) {
    if (data != null) {
      int _err = 0;
      int _len = (data['x'] as List).length;
      if ((data['y'] as List).length < _len) _len = (data['y'] as List).length;
      for (int i = 0; i < _len; i++) {
        _err += super.addMoreValues(data['x'][i], data['y'][i]);
      }
      if (_err == 0) {
        // print('read data:');
        notifyListeners();
      }
    }
  }

  void clearAllData() {
    dataClean();
    _saveLastData();
    notifyListeners();
  }

  @override
  int addMoreValues(String xText, String yText) {
    int _err = super.addMoreValues(xText, yText);
    if (_err == 0) {
      _saveLastData();
      cancelEditValue();
    }
    return _err;
  }

  @override
  void removeOneValue(int index) {
    super.removeOneValue(index);
    _saveLastData();
    notifyListeners();
  }

  @override
  int swapData(int index) {
    final _res = super.swapData(index);
    if (_res == 0) {
      _saveLastData();
      notifyListeners();
    }
    return _res;
  }

  void approxTypeChange(int index) {
    approximationType = index;
    notifyListeners();
  }

  void changeDotType(int index) {
    dotTypeIndex = index;
    notifyListeners();
  }

  void changeDotSize(double size) {
    dotSize = size;
    notifyListeners();
  }

  void startEditValue(int value) {
    editIndex = value;
    currentXValue = getValueString('x', editIndex);
    currentYValue = getValueString('y', editIndex);
    focusOnText = 'x';
    notifyListeners();
  }

  void cancelEditValue() {
    editIndex = -1;
    focusOnText = currentXValue = currentYValue = '';
    notifyListeners();
    // FocusManager.instance.primaryFocus.unfocus();
  }

  int getPowValue(String flag) => powMap[flag];

  int changePowValue(String flag, int value){
    if((powMap[flag] + value).abs() <= powMaximum) {
      return powMap[flag] += value;
    } else {
      return null;
    }
  }

  /// read/write section
  Future<File> _saveSettings() async {
    final file = File('${_appDirectory.path}$_settingsJson');

    // String json = jsonEncode(mainDataToWrite);//Utils.correctJson(mainDataToWrite.toString());
    // print('---------------------local path: $localPath');
    // Write the file
    return file.writeAsString(_settingsModel.toString());
  }

  Future<void> _readSettingsData() async {
    SettingsModel _result = new SettingsModel();
    // print('call settings provider read data');
    _appDirectory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> _list = _appDirectory.listSync();
    _imagesList = [];
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].path.contains(".png")) {
        // print('read from local directory: ${_list[i].path}');
        final dataFile = File('${_list[i].path.split('.png')[0]}.json');
        final bool _haveData = await dataFile.exists();
        _imagesList.add(ImagePair(
            path: _list[i].path, selected: false, haveData: _haveData));
      }
    }
    final file = File('${_appDirectory.path}$_settingsJson');
    if (await file.exists())
      try {
        // Read the file
        String contents = await file.readAsString();
        // var _dec = json.decode(contents);
        _result.parseJson(contents);
        changeTheme(_result.themeId);
        changeLocale(_result.language);
        changeGridShow(_result.showGrid);
      } catch (e) {
        // If encountering an error, return 0
        debugPrint('catch $e');
      }
  }

  Future<File> _saveLastData([String fileName = '']) async {
    final String _name =
        fileName == '' ? '${_appDirectory.path}$_dataJson' : '$fileName.json';
    final file = File(_name);
    return file.writeAsString(getAllDataString());
  }

  void readSavedData({@required String fileName}) async {
    final String _name =
        '${_appDirectory.path}/${fileName.split('.png')[0]}.json';
    clearAllData();
    _readSavedData(_name);
  }

  Future<void> _readSavedData([String fileName = '']) async {
    if (_appDirectory == null)
      _appDirectory = await getApplicationDocumentsDirectory();
    final String _name =
        fileName == '' ? '${_appDirectory.path}$_dataJson' : fileName;
    final file = File(_name);
    if (await file.exists())
      try {
        // Read the file
        String contents = await file.readAsString();
        _restoreData(json.decode(contents)['data']);
        if (fileName != '') {
          _saveLastData();
        }
      } catch (e) {
        // If encountering an error, return 0
        debugPrint('catch $e');
      }
  }

  ///images functions

  ImagePair getImage(int index) {
    return _imagesList[index];
  }

  bool getImageSelection(int index) {
    return _imagesList[index].selected;
  }

  void setImageSelection(int index, bool value) {
    _imagesList[index].selected = value;
    notifyListeners();
  }

  bool isSomeImageSelected() {
    bool _res = false;
    for (int i = 0; i < _imagesList.length; i++)
      _res = _res || _imagesList[i].selected;
    return _res;
  }

  int getImagesLength() => _imagesList.length;

  void saveCurrentData(var pngBytes) {
    final _fileName =
        '${_appDirectory.path}/graph_${StringUtils.replaceOneSymbol('${DateTime.now()}', ':', '-')}';
    final _pngPath = '$_fileName.png';
    File('$_pngPath').writeAsBytesSync(pngBytes.buffer.asInt8List());
    _saveLastData(_fileName);
    _imagesList.add(ImagePair(path: _pngPath, selected: false, haveData: true));
  }

  void deleteImage(int i) {
    final _dataFile = File('${_imagesList[i].path.split('.png')[0]}.json');
    if (_dataFile.existsSync()) {
      _dataFile.deleteSync();
    }
    File(_imagesList[i].path).deleteSync();
    _imagesList.removeAt(i);

    notifyListeners();
  }

  /// settings bar

  final _collapsedHeight = 60.0;
  final expandedHeight = 300.0;
  bool _settingsBarIsCollapsed = true;

  double get graphOffset => _settingsBarIsCollapsed ? _collapsedHeight : expandedHeight;
  bool get isGraphSettingCollapsed => _settingsBarIsCollapsed;

  void resetGraphSettingCollapsed() => _settingsBarIsCollapsed = true;

  void toggleCollaps(){
    _settingsBarIsCollapsed = !_settingsBarIsCollapsed;
    notifyListeners();
  }

}