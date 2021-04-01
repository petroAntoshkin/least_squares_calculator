import 'dart:math';

import 'package:flutter/material.dart';
import 'package:least_squares/elements/drop_down_list.dart';
import 'package:least_squares/elements/list_widgets/approx_linear.dart';
import 'package:least_squares/elements/list_widgets/approx_log.dart';
import 'package:least_squares/elements/list_widgets/approx_parabolic.dart';
import 'package:least_squares/elements/list_widgets/approx_pow.dart';
import 'package:least_squares/elements/list_widgets/dot_circle.dart';
import 'package:least_squares/elements/list_widgets/dot_rhomb.dart';
import 'package:least_squares/elements/list_widgets/dot_square.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/models/axis_label_model.dart';
import 'package:least_squares/models/graphic_data.dart';
import 'package:least_squares/models/named_widget.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GraphSettingsBar extends StatefulWidget {
  String _loc;

  @override
  _GraphSettingsBarState createState() => _GraphSettingsBarState();
}

class _GraphSettingsBarState extends State<GraphSettingsBar> {
  ThemeData _themeData;
  GraphicData _graphicsData;
  bool _settingsBarCollapsed = true;
  double _maxSize;

  Map<int, NamedWidget> _approxMap = Map();
  Map<int, NamedWidget> _dotsMap = Map();
  int _approximationType = 0, _dotType = 0;
  AxisLabelModel _labelModelX, _labelModelY;
  final double _buttonSize = 48.0, _iconSize = 22.0;

  final TextEditingController _controllerX = TextEditingController(),
      _controllerY = TextEditingController();

  _GraphSettingsBarState() {
    _approxMap = Map();
    _dotsMap = Map();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maxSize =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    widget._loc = Provider.of<DataProvider>(context).getLanguage();
    _themeData = Provider.of<DataProvider>(context, listen: false).theme;
    _graphicsData =
        Provider.of<DataProvider>(context, listen: false).graphicData;

    _approximationType = Provider.of<DataProvider>(context).approximationType;
    _dotType = Provider.of<DataProvider>(context).dotTypeIndex;
    _labelModelX = Provider.of<DataProvider>(context).getAxisModel('x');
    _labelModelY = Provider.of<DataProvider>(context).getAxisModel('y');
    _approxMap[0].widget = ApproxLinear(
      color: _themeData.primaryTextTheme.bodyText1.color,
    );
    _approxMap[1].widget = ApproxParabolic(
      color: _themeData.primaryTextTheme.bodyText1.color,
    );
    _approxMap[2].widget = ApproxPow(
      color: _themeData.primaryTextTheme.bodyText1.color,
    );
    _approxMap[3].widget = ApproxLog(
      color: _themeData.primaryTextTheme.bodyText1.color,
    );

    // widget._appMap[4] = 'exponential';
    // widget._appMap[5] = 'hyperbolic';
    _dotsMap[0].widget = DotCircle(
      color: _themeData.primaryTextTheme.bodyText1.color,
    );
    _dotsMap[1].widget = DotSquare(
      color: _themeData.primaryTextTheme.bodyText1.color,
    );
    _dotsMap[2].widget = DotRhomb(
      color: _themeData.primaryTextTheme.bodyText1.color,
    );
    return Container(
      decoration: BoxDecoration(
        color: _themeData.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _settingsBarCollapsed = !_settingsBarCollapsed;
              });
            },
            child: SizedBox(
              width: _maxSize,
              height: 30.0,
              child: Container(
                color: Color(0x00ff0000),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x55000000),
                        Color(0x01000000),
                        Color(0x01000000),
                        Color(0x01000000),
                      ]
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40.0,
                      ),
                      Text(
                        MyTranslations().getLocale(widget._loc, 'customization'),
                        style: TextStyle(
                          color: _themeData.primaryTextTheme.bodyText1.color,
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                        child: Center(
                          child: Icon(
                            _settingsBarCollapsed
                                ? Icons.arrow_drop_up_outlined
                                : Icons.arrow_drop_down_outlined,
                            color: _themeData.primaryTextTheme.bodyText1.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _settingsBarCollapsed
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 26.0,
                      child: Slider(
                        value: _graphicsData.dotSize,
                        min: 3.0,
                        max: 14.0,
                        divisions: 32,
                        onChanged: (value) {
                          Provider.of<DataProvider>(context, listen: false)
                              .changeDotSize(value);
                          setState(() {});
                        },
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
                                value: _graphicsData.showGrid,
                                onChanged: (value) {
                                  // print('chane checkBox value to $value');
                                  Provider.of<DataProvider>(context,
                                          listen: false)
                                      .changeGridShow(value);
                                  setState(() {});
                                },
                              ),
                              Text(
                                MyTranslations()
                                    .getLocale(widget._loc, 'show_grid'),
                                style: TextStyle(
                                  color: _themeData
                                      .primaryTextTheme.bodyText1.color,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropDownList(
                              itemsList: _approxMap,
                              currentValue: _approximationType,
                              callBack: _changeApproximationType,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropDownList(
                              itemsList: _dotsMap,
                              currentValue: _dotType,
                              callBack: _changeDotType,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Table(
                        border: TableBorder.all(color: Color(0x55000000)),
                        columnWidths: {
                          0: FlexColumnWidth(50),
                          1: FlexColumnWidth(50),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(
                                    '${MyTranslations().getLocale(widget._loc, 'axis_description')} (X)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _themeData
                                          .primaryTextTheme.bodyText1.color,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(
                                    '${MyTranslations().getLocale(widget._loc, 'axis_description')} (Y)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _themeData
                                          .primaryTextTheme.bodyText1.color,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: _editTextField(
                                    _controllerX,
                                    Provider.of<DataProvider>(context,
                                            listen: false)
                                        .getAxisModel('x')
                                        .text,
                                    'x'),
                              ),
                              TableCell(
                                child: _editTextField(
                                    _controllerY,
                                    Provider.of<DataProvider>(context,
                                            listen: false)
                                        .getAxisModel('y')
                                        .text,
                                    'y'),
                              ),
                            ],
                          ),
                          TableRow(children: [
                            TableCell(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: _buttonSize,
                                  height: _buttonSize,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Provider.of<DataProvider>(context,
                                              listen: false)
                                          .changeLabelVis(
                                              'x', !_labelModelX.visibility);
                                    },
                                    child: Center(
                                      child: Icon(
                                        _labelModelX.visibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: _themeData
                                            .primaryTextTheme.bodyText1.color,
                                        size: _iconSize,
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: _buttonSize,
                                //   height: _buttonSize,
                                //   child: MaterialButton(
                                //     onPressed: () {
                                //       Provider.of<DataProvider>(context,
                                //               listen: false)
                                //           .changeLabelRotation('x');
                                //     },
                                //     child: Center(
                                //       child: Icon(
                                //         Icons.rotate_90_degrees_ccw_outlined,
                                //         color: _themeData
                                //             .primaryTextTheme.bodyText1.color,
                                //         size: _iconSize,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  width: _buttonSize,
                                  height: _buttonSize,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Provider.of<DataProvider>(context,
                                          listen: false)
                                          .changeLabelFlip(
                                          'x', !_labelModelX.flipped);
                                    },
                                    child: Center(
                                      child: Transform.rotate(
                                        angle: _labelModelX.flipped ? pi/2 : pi * 1.5,
                                        child: Icon(
                                          Icons.flip_outlined,
                                          color: _themeData
                                              .primaryTextTheme.bodyText1.color,
                                          size: _iconSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            TableCell(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: _buttonSize,
                                  height: _buttonSize,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Provider.of<DataProvider>(context,
                                              listen: false)
                                          .changeLabelVis(
                                              'y', !_labelModelY.visibility);
                                    },
                                    child: Center(
                                      child: Icon(
                                        _labelModelY.visibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: _themeData
                                            .primaryTextTheme.bodyText1.color,
                                        size: _iconSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _buttonSize,
                                  height: _buttonSize,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Provider.of<DataProvider>(context,
                                              listen: false)
                                          .changeLabelRotation('y');
                                    },
                                    child: Center(
                                      child: Icon(
                                        Icons.rotate_90_degrees_ccw_outlined,
                                        color: _themeData
                                            .primaryTextTheme.bodyText1.color,
                                        size: _iconSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _buttonSize,
                                  height: _buttonSize,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Provider.of<DataProvider>(context,
                                              listen: false)
                                          .changeLabelFlip(
                                              'y', !_labelModelY.flipped);
                                    },
                                    child: Center(
                                      child: Transform.rotate(
                                        angle: _labelModelY.flipped ? pi : 0,
                                        child: Icon(
                                          Icons.flip_outlined,
                                          color: _themeData
                                              .primaryTextTheme.bodyText1.color,
                                          size: _iconSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  ///axis description controllers
  Widget _editTextField(
      TextEditingController controller, String initialText, String identifier) {
    controller.text = initialText;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      // decoration: BoxDecoration(),
      child: TextField(
        // onChanged: (value) {
        //   Provider.of<DataProvider>(context, listen: false)
        //       .changeLabelText(identifier, value);
        // },
        onEditingComplete: () {
          Provider.of<DataProvider>(context, listen: false)
              .changeLabelsText(_controllerX.text, _controllerY.text);
        },
        textAlign: TextAlign.center,
        cursorColor: _themeData.primaryTextTheme.bodyText1.color,
        style: TextStyle(
          color: _themeData.primaryTextTheme.bodyText1.color,
        ),
        controller: controller,
      ),
    );
  }

  ///dot type changing
  void _changeDotType(int index) {
    //print('changeApproximationType to $index');
    setState(() {
      Provider.of<DataProvider>(context, listen: false).changeDotType(index);
    });
  }

  ///approximation functions
  ///
  void _changeApproximationType(int index) {
    //print('changeApproximationType to $index');
    setState(() {
      _approximationType = index;
      Provider.of<DataProvider>(context, listen: false).approxTypeChange(index);
    });
  }
}