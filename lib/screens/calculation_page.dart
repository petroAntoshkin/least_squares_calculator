import 'package:flutter/material.dart';
import 'package:least_squares/data_provider.dart';
import 'package:least_squares/localization.dart';

import 'package:least_squares/styles_and_presets.dart';
import 'package:provider/provider.dart';

class CalculationPage extends StatefulWidget {
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  String _loc;
  double _currentX, _currentY;
  final TextEditingController _controllerX = TextEditingController(),
      _controllerY = TextEditingController();

  // List<double> _xValues;
  // List<double> _yValues;

  @override
  void initState() {
    super.initState();
    _loc = 'en'; //Localizations.localeOf(context).languageCode;
    _controllerX.text = _currentX.toString();
    _controllerY.text = _currentY.toString();
    _clearControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DataProvider>(context).initData(_loc);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              color: Colors.red,
              child: Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.47,
                    child: _valueText(Provider.of<DataProvider>(context).getA(),
                        Presets.resultsValueStyle),
                  ),
                  Expanded(child: Container()),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.47,
                    child: _valueText(Provider.of<DataProvider>(context).getB(),
                        Presets.resultsValueStyle),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              color: Colors.green,
              child: LimitedBox(
                  maxHeight: 200,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      child: ListView(
                        children: [
                          for (int i = 0; i < Provider.of<DataProvider>(context, listen: false).getValuesLenght(); i++)
                            _oneValueRow(i)
                        ],
                      ),
                    ),
                  ])),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              color: Colors.blue,
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
                          MyLocalization()
                              .getLocale(_loc, 'calculateButtonName'),
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      color: Colors.red,
                      highlightedBorderColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () => Provider.of<DataProvider>(context,
                              listen: false)
                          .addMoreValues(_controllerX.text, _controllerY.text),
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
          ),
        ),
      ]),
    );
  }

  void _clearControllers() {
    _controllerX.clear();
    _controllerY.clear();
    _controllerX.text = '0';
    _controllerY.text = '0';
  }

  Widget _editTextField(TextEditingController controller, String prefix) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        labelText: prefix,
      ),
    );
  }

  Widget _valueText(String text, TextStyle style) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
            child: Text(text,),
          )),
    );
  }

  Widget _oneValueRow(int index) {
    return Card(
      color: Colors.white38,
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Provider.of<DataProvider>(context, listen: false)
                  .removeOneValue(index)),
          _valueText(
              'X = ${Provider.of<DataProvider>(context, listen: false).getValueX(index)}',
              Presets.currrentValueStyle),
          _valueText(
              'Y = ${Provider.of<DataProvider>(context, listen: false).getValueY(index)}',
              Presets.currrentValueStyle),
        ],
      ),
    );
  }
}
