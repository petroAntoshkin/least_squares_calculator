import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:least_squares/elements/values_pair.dart';
import 'package:least_squares/providers/data_provider.dart';
// import 'package:least_squares/my_translations.dart';

//
// import 'package:least_squares/styles_and_presets.dart';
import 'package:provider/provider.dart';

class CalculationPage extends StatefulWidget {
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  // double _currentX, _currentY;
  final TextEditingController _controllerX = TextEditingController(),
      _controllerY = TextEditingController();

  // List<double> _xValues;
  // List<double> _yValues;

  @override
  void initState() {
    super.initState();
    // _loc = 'en'; //Localizations.localeOf(context).languageCode;
    _controllerX.text = '';//_currentX.toString();
    _controllerY.text = '';//_currentY.toString();
    // _clearControllers();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Provider.of<DataProvider>(context).initData(_loc);
  // }

  @override
  Widget build(BuildContext context) {
    int _dataLen = Provider.of<DataProvider>(context).getValuesLength();
    // print('CalculationPage build $_dataLen');
    return Center(
      child: Stack(children: [
        ListView(children: [
          for (int i = 0; i < _dataLen; i++)
            ValuesPair(pairIndex: i)
        ]),
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
                    padding: EdgeInsets.all(10.0),
                    // ignore: deprecated_member_use
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        // color: Colors.white54,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white60,
                          border: Border.all(
                            color: Colors.black54,
                            width: 1.0
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          // margin: EdgeInsets.all(2.0),
                          child: Icon(Icons.calculate),
                        ),
                      ),
                      onTap: () {
                        print(
                            'x = ${_controllerX.text} y = ${_controllerY.text}');
                        Provider.of<DataProvider>(context, listen: false)
                            .addMoreValues(
                                _controllerX.text, _controllerY.text);
                        _clearControllers();
                      },
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
  }

  Widget _editTextField(TextEditingController controller, String prefix) {
    return Container(
      decoration: BoxDecoration(),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: controller,
        decoration: InputDecoration(
          hintText: prefix,
          fillColor: Colors.white54,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff777777), width: 1.0),
            borderRadius: BorderRadius.circular(6.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff333333), width: 1.0),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }
}
