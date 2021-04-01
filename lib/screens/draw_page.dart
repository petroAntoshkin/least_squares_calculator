import 'dart:ui' as ui;
import 'dart:typed_data';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:least_squares/elements/axis_label.dart';
import 'package:least_squares/elements/graph_settings_bar.dart';
import 'package:least_squares/utils/string_utils.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';

import 'package:least_squares/elements/graph_painter.dart';
import 'package:least_squares/models/graphic_data.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:least_squares/mocks/my_translations.dart';

// ignore: must_be_immutable
class DrawPage extends StatefulWidget {
  String _loc;

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final double _gridIndexDisplace = 4.0;
  GlobalKey _globalKey = new GlobalKey();

  double _maxSize;
  final double _sizeMultiplier = 1;
  final _displaceNotifier = ValueNotifier<double>(0);
  final int _gridCount = 10;

  String dragDirection;
  double _startDXPoint, _startDYPoint, _startDisplaceX, _startDisplaceY;
  Positioned _axisLabelX, _axisLabelY;

  ThemeData _themeData;
  GraphicData _newGD;

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DataProvider>(context, listen: false)
        .setContextFunction(_exportGraph);
    _maxSize =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;

    Provider.of<DataProvider>(context, listen: false).maxSize =
        _maxSize * _sizeMultiplier;
  }

  @override
  Widget build(BuildContext context) {
    _newGD = Provider.of<DataProvider>(context, listen: false).graphicData;
    _themeData = Provider.of<DataProvider>(context, listen: false).theme;
    FocusManager.instance.primaryFocus.unfocus();
    int _len = Provider.of<DataProvider>(context).getValuesLength();
    widget._loc = Provider.of<DataProvider>(context).getLanguage();

    _axisLabelX = Positioned(
      child: AxisLabel(label: 'x'),
      right: 4.0,
      top: _maxSize / 2 + _newGD.displaceY,
    );
    _axisLabelY = Positioned(
      child: AxisLabel(label: 'y'),
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
                  child: _len != 0
                      ? GestureDetector(
                          onScaleStart: _onScaleStart,
                          onScaleUpdate: _onScaleUpdate,
                          child: _drawStack,
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
              ),
              Align(
                alignment: Alignment.bottomCenter,
                // child: _settingsBar(),
                child: GraphSettingsBar(),
              ),
            ],
          );
  }

  ///axis indexes
  void _getAxisIndexes(List<Widget> _children) {
    if (_newGD.gridCount != null) {
      for (int i = -_newGD.gridCount + 1; i < _newGD.gridCount; i += 2)
        _children.add(_getIndexX(i));
      for (int i = -_newGD.gridCount + 1; i < _newGD.gridCount; i += 2)
        _children.add(_getIndexY(i));
      _children.add(_axisLabelX);
      _children.add(_axisLabelY);
    }
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
      StringUtils.decreaseZeroGroups(
      '${_newGD.zoomFactorX <= 0 ? index ~/ pow(_gridCount, _newGD.zoomFactorX) : index / pow(_gridCount, _newGD.zoomFactorX)}'),
        style: TextStyle(
          color: _themeData.primaryTextTheme.bodyText1.color,
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
        '${_newGD.zoomFactorY <= 0 ? -index ~/ pow(_gridCount, _newGD.zoomFactorY) : (-index / pow(_gridCount, _newGD.zoomFactorY))}',
        style: TextStyle(
          color: _themeData.primaryTextTheme.bodyText1.color,
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
    // _startMetamorphFactor = _metamorphosisFactor;
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
    _capturePng();
  }

  void _capturePng() async {
    Dialogs.materialDialog(
      context: context,
      customView: CircularProgressIndicator(),
      dialogShape: null,
    );
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      // var bs64 = base64Encode(pngBytes);
      Provider.of<DataProvider>(context, listen: false).savePNG(pngBytes);
      // print(pngBytes);
      // print(bs64);
      // return pngBytes;
      Navigator.pop(context);
      Dialogs.materialDialog(
        context: context,
        customView: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.memory(pngBytes),
        ),
        actions: [
          IconsOutlineButton(
            onPressed: () => Navigator.pop(context),
            iconData: Icons.check,
            iconColor: Colors.green,
            text: '',
          ),
        ],
      );
    } catch (e) {
      // print(e);
      Navigator.pop(context);
      Dialogs.materialDialog(
        context: context,
        msg: '$e',
        actions: [
          IconsOutlineButton(
            onPressed: () => Navigator.pop(context),
            iconData: Icons.error_outline,
            iconColor: Colors.redAccent,
            text: '',
          ),
        ],
      );
    }
  }
}
