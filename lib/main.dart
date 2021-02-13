import 'package:flutter/material.dart';
import 'package:least_squares/localization.dart';
import 'package:least_squares/styles_and_presets.dart';
import 'package:least_squares/utils/string_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Least Squares',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LSMHomePage(title: 'Least Squares Page'),
    );
  }
}

class LSMHomePage extends StatefulWidget {
  LSMHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LSMHomePageState createState() => _LSMHomePageState();
}

class _LSMHomePageState extends State<LSMHomePage> {

  double _a, _b, _currentX, _currentY;
  final TextEditingController _controllerX = TextEditingController(),
      _controllerY = TextEditingController();
  List<double> _xValues;
  List<double> _yValues;

  void _initValues() {
    setState(() {
      _initSum();
      _xValues = [];
      _yValues = [];
    });
  }

  void _initSum() {
    _a = _b = _currentX = _currentY = 0;
  }void _addMoreValues() {
    double _resX, _resY;
    bool _err = false;
    try {
      _resX = double.parse(StringUtils.normalizeDouble(_controllerX.text));
      _resY = double.parse(StringUtils.normalizeDouble(_controllerY.text));
    } catch (e) {
      _err = true;
    }
    if(!_err) {
      _xValues.add(_resX);
      _yValues.add(_resY);
      _clearControllers();
      _countAB();
      setState(() {});
    } else{
      _clearControllers();
    }
  }

  void _clearControllers() {
    _controllerX.clear();
    _controllerY.clear();
    _controllerX.text = '0';
    _controllerY.text = '0';
  }

  Widget _editTextField(TextEditingController controller, String prefix) {
    return
      TextField(
        decoration: InputDecoration(
          filled: true,
          labelText: prefix,
        ),
      );
    //   TextField(
    //   style: Presets.currrentValueStyle,
    //   controller: controller,
    //   decoration: InputDecoration(
    //       // prefix: Text(prefix),
    //       labelText: prefix,
    //       filled: true,
    //       fillColor: Colors.white54,
    //       disabledBorder: OutlineInputBorder(
    //         borderRadius: Presets.defaultBorderRadius,
    //       ),
    //       enabledBorder: OutlineInputBorder(
    //         borderRadius: Presets.defaultBorderRadius,
    //       )
    //   ),
    // );
  }

  Widget _valueText(String text, TextStyle style) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
            child: Text(
              text,
              style: style,
            ),
          )),
    );
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

  void _removeOneValue(int index) {
    _xValues.removeAt(index);
    _yValues.removeAt(index);
    setState(() {});
  }

  Widget _oneValueRow(int index) {
    return Card(
      color: Colors.white38,
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.close), onPressed: () => _removeOneValue(index)),
          _valueText('X = ${_xValues[index]}', Presets.currrentValueStyle),
          _valueText('Y = ${_yValues[index]}', Presets.currrentValueStyle),
        ],
      ),
    );
  }

  @override
  void initState() {
    _initValues();
    _controllerX.text = _currentX.toString();
    _controllerY.text = _currentY.toString();
    _clearControllers();
  }

  @override
  Widget build(BuildContext context) {
    String _loc = 'en';//Localizations.localeOf(context).languageCode;
    String _nanString = MyLocalization().getLocale(_loc, 'nanMessage');
    print("loc is $_loc");
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalization().getLocale(_loc, 'title')),
      ),
      body: Center(
        child: ListView(children: [
          Card(
              color: Colors.amberAccent,
              child: Column(
                children: [
                  // padding: EdgeInsets.all(5.0),
                  LimitedBox(
                      maxHeight: 200,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(
                          child: ListView(
                            children: [
                              for (int i = 0; i < _xValues.length; i++)
                                _oneValueRow(i)
                            ],
                          ),
                        ),
                      ])),
                  Container(
                    color: Colors.green,
                    child: Row(
                      children: [
                        // ignore: deprecated_member_use
                        Container(
                          padding: EdgeInsets.all(5.0),
                          // ignore: deprecated_member_use
                          child: OutlineButton(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              // margin: EdgeInsets.all(2.0),
                              child: Text(
                                MyLocalization().getLocale(_loc, 'calculateButtonName'),
                                style: TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            color: Colors.red,
                            highlightedBorderColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: _addMoreValues,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Container(
                              margin: EdgeInsets.all(4.0),
                              child: _editTextField(_controllerX, ' X '),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Container(
                              margin: EdgeInsets.all(4.0),
                              child: _editTextField(_controllerY, ' Y '),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    padding: EdgeInsets.all(0),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _valueText(_a.isNaN ? _nanString : 'A = $_a', Presets.resultsValueStyle),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _valueText(_b.isNaN ? _nanString : 'B = $_b', Presets.resultsValueStyle),
                            ]),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                  )
                ],
              )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _initValues,
        tooltip: 'Reset',
        child: Icon(Icons.close),
      ),
    );
  }
}
