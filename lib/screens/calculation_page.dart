import 'package:flutter/material.dart';
import 'package:least_squares/elements/values_pair.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';

class CalculationPage extends StatefulWidget {
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  ThemeData _themeData;
  DataProvider _dataProvider;
  final TextEditingController _controllerX = TextEditingController(),
      _controllerY = TextEditingController();
  final FocusNode _xFocusNode = FocusNode();

  int _dataLen;
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    _controllerX.text = '';
    _controllerY.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DataProvider>(context, listen: false)
        .setContextFunction(_bottomNavFunction);
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    _dataLen = _dataProvider.getValuesLength();
    _themeData = _dataProvider.theme;
    _context = context;
    // print('CalculationPage build $_dataLen');
    return Center(
      child: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          child: ListView(children: [
            for (int i = 0; i < _dataLen; i++) ValuesPair(pairIndex: i)
          ]),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              color: _themeData.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.07,
                      // width: MediaQuery.of(context).size.height * 0.07,
                      height: 40.0,
                      width: 40.0,
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 10.0),
                        // ignore: deprecated_member_use
                        child: GestureDetector(
                          child: Container(
                            // padding: EdgeInsets.symmetric(horizontal: 8.0),
                            // color: Colors.red,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10.0),
                              color: _themeData.primaryColorDark,
                              border:
                                  Border.all(color: Colors.black54, width: 1.0),
                            ),
                            child: Center(
                              child: Icon(
                                _dataProvider.editIndex == -1
                                    ? Icons.calculate
                                    : Icons.check,
                                color: _themeData.accentColor,
                              ),
                            ),
                          ),
                          onTap: () {
                            _addValuesRequest();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: (MediaQuery.of(context).size.width - 100) / 2,
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: _editTextField(
                          _controllerX,
                          ' X ',
                          _xFocusNode,
                          _dataProvider.getValueString(
                              'x', _dataProvider.editIndex)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    // width: MediaQuery.of(context).size.width * 0.35,
                    width: (MediaQuery.of(context).size.width - 100) / 2,
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: _editTextField(
                          _controllerY,
                          ' Y ',
                          null,
                          _dataProvider.getValueString(
                              'y', _dataProvider.editIndex)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 10.0),
                        // ignore: deprecated_member_use
                        child: GestureDetector(
                          child: Container(
                            // padding: EdgeInsets.symmetric(horizontal: 8.0),
                            // color: Colors.red,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10.0),
                              color: _themeData.primaryColorDark,
                              border:
                                  Border.all(color: Colors.black54, width: 1.0),
                            ),
                            child: Center(
                              child: Icon(
                                _dataProvider.editIndex == -1
                                    ? Icons.calculate
                                    : Icons.cancel_outlined,
                                color: _themeData.accentColor,
                              ),
                            ),
                          ),
                          onTap: () {
                            _dataProvider.editIndex == -1
                                ? _addValuesRequest()
                                : _cancelEdit();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void _cancelEdit(){
    Provider.of<DataProvider>(context, listen: false).cancelEditValue();
    FocusManager.instance.primaryFocus.unfocus();
  }

  void _addValuesRequest() {
    int _error = Provider.of<DataProvider>(context, listen: false)
        .addMoreValues(_controllerX.text, _controllerY.text);
    if (_error == 0) {
      _clearControllers();
      _xFocusNode.requestFocus();
    } else {
      Dialogs.materialDialog(
        customView: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 50.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                MyTranslations().getLocale(
                    Provider.of<DataProvider>(_context, listen: false)
                        .getLanguage(),
                    'equal_data_error_$_error'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        context: _context,
        actions: [
          IconsOutlineButton(
            onPressed: () => Navigator.pop(context),
            text: 'ok',
          ),
        ],
      );
    }
  }

  void _clearControllers() {
    _controllerX.clear();
    _controllerY.clear();
  }

  Widget _editTextField(TextEditingController controller, String prefix,
      FocusNode focusNode, String valueString) {
    controller.text = valueString;
    if(_controllerX.text.isNotEmpty)
      _xFocusNode.requestFocus();
    return Container(
      decoration: BoxDecoration(),
      child: TextField(
        focusNode: focusNode,
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
            borderSide: BorderSide(color: Color(0xff777777), width: 1.0),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  void _bottomNavFunction() {
    if (_dataLen > 0) {
      Dialogs.bottomMaterialDialog(
        msg: MyTranslations().getLocale(
            Provider.of<DataProvider>(_context, listen: false).getLanguage(),
            'del_approve'),
        title: MyTranslations().getLocale(
            Provider.of<DataProvider>(_context, listen: false).getLanguage(),
            'reset'),
        context: _context,
        actions: [
          IconsOutlineButton(
            onPressed: () => Navigator.pop(context),
            text: MyTranslations().getLocale(
                Provider.of<DataProvider>(context, listen: false).getLanguage(),
                'cancel'),
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              Provider.of<DataProvider>(context, listen: false).clearAllData();
              Navigator.pop(context);
            },
            text: MyTranslations().getLocale(
                Provider.of<DataProvider>(context, listen: false).getLanguage(),
                'delete'),
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );
    }
  }
}
