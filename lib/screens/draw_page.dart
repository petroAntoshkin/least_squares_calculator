import 'dart:ui' as ui;
import 'dart:typed_data';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:least_squares_calculator/elements/axis_label.dart';
import 'package:least_squares_calculator/elements/graph_settings_bar.dart';
import 'package:least_squares_calculator/elements/my_focus_button.dart';
import 'package:least_squares_calculator/elements/results_bar.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';
import 'package:least_squares_calculator/utils/string_utils.dart';

// import 'package:material_dialogs/material_dialogs.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';

import 'package:least_squares_calculator/elements/graph_painter.dart';
import 'package:least_squares_calculator/models/graphic_data.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:least_squares_calculator/mocks/my_translations.dart';

// ignore: must_be_immutable
class DrawPage extends StatefulWidget {
  String _loc = 'en';

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final double _gridIndexDisplace = 4.0;
  GlobalKey _globalKey = new GlobalKey();

  double _maxSize = 1.0;
  final double _sizeMultiplier = 1;
  final _displaceNotifier = ValueNotifier<double>(0);
  final int _gridCount = 10;

  String dragDirection = '';
  double _startDXPoint = .0, _startDYPoint = .0, _startDisplaceX = .0, _startDisplaceY = .0;
  Positioned _axisLabelX = Positioned(child: Container()), _axisLabelY = Positioned(child: Container());

  ThemeData _themeData = ThemeData();
  GraphicData _newGD = GraphicData(dataDots: [], trendDots: []);

  int _len = 0;

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  bool exportEnabled = true;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus!.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Provider.of<DataProvider>(context, listen: false)
    //     .setContextFunction(1, _exportGraph);
    _maxSize =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;

    Provider.of<DataProvider>(context, listen: false).maxSize =
        _maxSize * _sizeMultiplier;
    _themeData = Provider.of<DataProvider>(context, listen: false).theme;
    widget._loc =
        Provider.of<DataProvider>(context, listen: false).getLanguage();
    _len = Provider.of<DataProvider>(context, listen: false).getValuesLength();
  }

  @override
  Widget build(BuildContext context) {
    // print('--------------------------------------------draw page rebuilded-------------------------');
    _newGD = Provider.of<DataProvider>(context, listen: false).graphicData;
    widget._loc =
        Provider.of<DataProvider>(context, listen: false).getLanguage();
    _axisLabelX = Positioned(
      child: AxisLabel(label: 'x', direction: '',),
      right: 4.0,
      top: _maxSize / 2 + _newGD.displaceY,
    );
    _axisLabelY = Positioned(
      child: AxisLabel(label: 'y', direction: '',),
      left: _maxSize / 2 + _newGD.displaceX,
      // top: _maxSize / 2 + _newGD.displaceY,
    );

    Stack _drawStack = Stack(
      children: [
        _newGD.dataDots.isNotEmpty
            ? CustomPaint(
                size: Size(_maxSize, _maxSize),
                painter: DrawPainter(
                  repaint: _displaceNotifier,
                  graphicData: _newGD,
                  themeData: _themeData,
                ),
              )
            : Container(),
      ],
    );
    if (_newGD.dataDots.isNotEmpty) _getAxisIndexes(_drawStack.children);

    return _keyboardIsVisible()
        ? Container()
        : Stack(
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: SizedBox(
                  width: _maxSize * _sizeMultiplier,
                  height: _maxSize * _sizeMultiplier,
                  child: _len > 1
                      ? GestureDetector(
                          onScaleStart: _onScaleStart,
                          onScaleUpdate: _onScaleUpdate,
                          child: _drawStack,
                        )
                      : Container(),
                ),
              ),
              Positioned(
                top: _maxSize * _sizeMultiplier,
                child: SizedBox(
                  width: _maxSize * _sizeMultiplier,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          _len > 1 ? 'y = ax + b' : '',
                          style: TextStyle(
                            color: _themeData.indicatorColor,
                            fontStyle: FontStyle.italic,
                            fontSize: Presets.TEXT_SIZE_MIDDLE,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      _len > 1 ? ResultBar() : Container(),
                    ],
                  ),
                ),
              ),
              _len < 2 ?Align(
                alignment: Alignment.center,
                child: Text(
                  MyTranslations().getLocale(widget._loc, _len == 0 ? 'nanData' : 'nanMessage'),
                  style: TextStyle(
                    color: _themeData.indicatorColor,
                  ),
                ),
              ) : Container(),

              /// graph settings
              _len > 1 ? GraphSettingsBar() : Container(),
              Positioned(
                // Provider.of<DataProvider>(context).graphOffset
                left: MediaQuery.of(context).size.width / 2 -
                    Presets.MINIMUM_TAP_SIZE,
                bottom: Provider.of<DataProvider>(context).graphOffset -
                    Presets.MINIMUM_TAP_SIZE +
                    Presets.ARC_SIZE,
                child: _len > 1
                    ? MyFocusButton(
                        callback: () => _exportGraph,
                        text: 'export_short',
                      )
                    : Container(),
              ),
            ],
          );
  }

  ///axis indexes
  void _getAxisIndexes(List<Widget> _children) {
    // if (_newGD.gridCount != null) {
      for (int i = -_newGD.gridCount + 1; i < _newGD.gridCount; i += 2) {
        _children.add(_getIndexX(i));
        _children.add(_getIndexY(i));
      }
      _children.add(_axisLabelX);
      _children.add(_axisLabelY);
    // }
    // return _result;
  }

  Widget _getIndexX(int index) {
    return Positioned(
      top: _maxSize / 2 + _newGD.displaceY + _gridIndexDisplace,
      left: _maxSize / 2 +
          _newGD.displaceX +
          _gridIndexDisplace +
          index *
              Provider.of<DataProvider>(context, listen: false).pixelsPerGrid,
      child: Text(
        _newGD.zoomFactorX <= 0
            ? StringUtils.normalizeNumberView(
                index ~/ pow(_gridCount, _newGD.zoomFactorX))
            : StringUtils.normalizeNumberView(
                (index / pow(_gridCount, _newGD.zoomFactorX))),
        style: TextStyle(
          color: _themeData.indicatorColor,
        ),
      ),
    );
  }

  Widget _getIndexY(int index) {
    return Positioned(
      left: _maxSize / 2 + _newGD.displaceX + _gridIndexDisplace,
      top: _maxSize / 2 +
          _newGD.displaceY +
          _gridIndexDisplace +
          index *
              Provider.of<DataProvider>(context, listen: false).pixelsPerGrid,
      child: Text(
        _newGD.zoomFactorY <= 0
            ? StringUtils.normalizeNumberView(
                -index ~/ pow(_gridCount, _newGD.zoomFactorY))
            : StringUtils.normalizeNumberView(
                (-index / pow(_gridCount, _newGD.zoomFactorY))),
        style: TextStyle(
          color: _themeData.indicatorColor,
        ),
      ),
    );
  }

  /// gesture functions
  ///
  void _onScaleStart(ScaleStartDetails scaleStartDetails) {
    this._startDXPoint = scaleStartDetails.focalPoint.dx.floorToDouble();
    this._startDYPoint = scaleStartDetails.focalPoint.dy.floorToDouble();
    _startDisplaceX = _newGD.displaceX;
    _startDisplaceY = _newGD.displaceY;
  }

  void _onScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    double _tempDisplace =
        scaleUpdateDetails.focalPoint.dx - this._startDXPoint;
    final _half = _newGD.maxSize / 2;
    if (_tempDisplace + _startDisplaceX < _half - _newGD.axisArrowOffset &&
        _tempDisplace + _startDisplaceX > -_half + _newGD.axisArrowOffset) {
      setState(() {
        Provider.of<DataProvider>(context, listen: false).displaceX =
            _newGD.displaceX =
                _displaceNotifier.value = _tempDisplace + _startDisplaceX;
      });
    }
    _tempDisplace = scaleUpdateDetails.focalPoint.dy - this._startDYPoint;
    if (_tempDisplace + _startDisplaceY < _half - _newGD.axisArrowOffset &&
        _tempDisplace + _startDisplaceY > -_half + _newGD.axisArrowOffset) {
      setState(() {
        Provider.of<DataProvider>(context, listen: false).displaceY =
            _newGD.displaceY =
                _displaceNotifier.value = _tempDisplace + _startDisplaceY;
      });
    }

    ///scale graphics maybe in the future
    //print('scale before: $_metamorphosisFactor');
    // if (scaleUpdateDetails.scale != 1.0)
    //   _metamorphosisFactor = _startMetamorphFactor * scaleUpdateDetails.scale;
    //print('scale after: $_metamorphosisFactor');
  }

  ///export graphic
  void _exportGraph() {
    if (exportEnabled) {
      _capturePng();
    }
    exportEnabled = false;
  }

  void _capturePng() async {
    if (_newGD.dataDots.length > 1) {
      var tt = showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        },
      );
      try {

        final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final Uint8List pngBytes = byteData!.buffer.asUint8List();

        // var bs64 = base64Encode(pngBytes);
        Provider.of<DataProvider>(context, listen: false)
            .saveCurrentData(pngBytes);
        // return pngBytes;
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.memory(pngBytes),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // print(e);
        Navigator.pop(context);
        SimpleDialog(
          children: [
            Text('$e'),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Icon(
                Icons.error_outline,
                color: Colors.redAccent,
              ),
            ),
          ],
        );
      }
      tt.then((value) => exportEnabled = true);
    }
  }
}
