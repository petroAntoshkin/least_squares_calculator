import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:least_squares_calculator/elements/blind.dart';
import 'package:least_squares_calculator/elements/bottom_nav_painter.dart';
import 'package:least_squares_calculator/elements/cancel_edit_button.dart';
import 'package:least_squares_calculator/elements/my_focus_button.dart';
import 'package:least_squares_calculator/elements/results_bar.dart';
import 'package:least_squares_calculator/elements/subscribed_icon_button.dart';
import 'package:least_squares_calculator/elements/pow_form.dart';
import 'package:least_squares_calculator/elements/value_text_field.dart';
import 'package:least_squares_calculator/elements/values_pair.dart';
import 'package:least_squares_calculator/mocks/my_translations.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';

// import 'package:least_squares_calculator/utils/string_utils.dart';
import 'package:provider/provider.dart';

class CalculationPage extends StatefulWidget {
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  final bottomPartHeight = 120.0;
  final valueTextHeight = 60.0;
  final powLimit = 10;
  final arcSize = Presets.ARC_SIZE;
  final TextEditingController _controllerX = TextEditingController(),
      _controllerY = TextEditingController();
  late ScrollController _dataScrollController;

  // int _xPow = 0, _yPow = 0;
  late BuildContext _context;

  bool editMode = false;


  @override
  Widget build(BuildContext context) {
    debugPrint('!!!!!!!!!!!!!!!!!! build calc page');
    _context = context;
    _dataScrollController = ScrollController();
    final _dataLen = Provider.of<DataProvider>(context).getValuesLength();
    final textFieldWidth =
        MediaQuery.of(context).size.width / 2 - Presets.MINIMUM_TAP_SIZE;
    return Center(
      child: Stack(children: [
        /// data list view
        SizedBox(
          height: MediaQuery.of(context).size.height -
              bottomPartHeight -
              Presets.APP_BAR_HEIGHT -
              Presets.NAV_BAR_HEIGHT -
              Presets.RESULTS_BAR_HEIGHT * 2,
          width: MediaQuery.of(context).size.width,
          child: Container(
            // color: Colors.redAccent,
            child: ListView.separated(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              controller: _dataScrollController,
              itemCount: _dataLen > 1
                  ? _dataLen + 1 : _dataLen,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                if (index >= _dataLen) {
                  return Padding(
                    padding: const EdgeInsets.all(Presets.ARC_SIZE / 2),
                    child: GestureDetector(
                      onTap: () => _clearData(),
                      child: SizedBox(
                        height: Presets.MINIMUM_TAP_SIZE + Presets.ARC_SIZE,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Provider.of<DataProvider>(context).theme.primaryColorLight,
                            borderRadius: BorderRadius.circular(Presets.ARC_SIZE),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Presets.MINIMUM_TAP_SIZE,
                                child: Icon(Icons.delete_outline),
                              ),
                              Text(MyTranslations().getLocale(
                                  Provider.of<DataProvider>(_context,
                                          listen: false)
                                      .getLanguage(),
                                  'reset')),
                              SizedBox(
                                width: Presets.MINIMUM_TAP_SIZE,
                                child: Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else
                  return ValuesPair(pairIndex: index);
              },
            ),
          ),
        ),

        /// blind

        Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: KeyboardVisibilityProvider(
                child: Blind(),
              ),
            ),
        ),

        /// bottom part
        /// bottom part background
        _dataLen > 0 ? Positioned(
          left: 0.0,
          bottom: 1.5 * Presets.ARC_SIZE + bottomPartHeight,
          child: ResultBar(),
        )
        : Align(
          alignment: Alignment.center,
          child: Text(
              MyTranslations().getLocale(Provider.of<DataProvider>(_context, listen: false).getLanguage(), 'nanData'),
            style: TextStyle(
              color: Provider.of<DataProvider>(context).theme.indicatorColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: bottomPartHeight,
            child: CustomPaint(
              painter: BottomNavPainter(
                color: Provider.of<DataProvider>(context).theme.primaryColorLight,
                holeHeight: Presets.MINIMUM_TAP_SIZE,
              ),
            ),
          ),
        ),

        ///
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: bottomPartHeight,
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: 5.0),
                  /// x10 pow buttons and clear button row
                  Padding(
                    padding: const EdgeInsets.only(bottom: Presets.ARC_SIZE),
                    child: SizedBox(
                      height: Presets.MINIMUM_TAP_SIZE,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: PowForm(
                              flag: 'x',
                              // powValue: _xPow,
                              // callback: _changePow,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: PowForm(
                              flag: 'y',
                              // powValue: _yPow,
                              // callback: _changePow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// input numbers and Confirm button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: valueTextHeight,
                        width: textFieldWidth,
                        child: Container(
                          child: ValueTextField(
                            flag: 'x',
                            callback: () => _addValuesRequest,
                            onChangeCallback: (value) => _controllerX.text = value,
                          ),
                        ),
                      ),
                      KeyboardVisibilityProvider(
                        child: CancelEditButton(callback: _cancelEdit),
                      ),
                      SizedBox(
                        height: valueTextHeight,
                        // width: MediaQuery.of(context).size.width * 0.35,
                        width: textFieldWidth,
                        child: Container(
                          child: ValueTextField(
                            flag: 'y',
                            callback: () => _addValuesRequest,
                            onChangeCallback: (value) => _controllerY.text = value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        /// confirm button
        Positioned(
          left:
              MediaQuery.of(context).size.width / 2 - Presets.MINIMUM_TAP_SIZE,
          bottom: 0.8 * Presets.ARC_SIZE +
              bottomPartHeight -
              Presets.MINIMUM_TAP_SIZE,
          child: MyFocusButton(
            callback: () => _addValuesRequest,
            text: 'confirm',
          ),
        ),
      ]),
    );
  }

  void _scrollDown() {
    debugPrint('_scrollDown list of data');
    if (_dataScrollController.positions.isNotEmpty) {
      _dataScrollController.jumpTo(_dataScrollController.position.maxScrollExtent);
    }
  }

  void _cancelEdit() {
    _clearControllers();
    Provider.of<DataProvider>(context, listen: false).cancelEditValue();
    FocusManager.instance.primaryFocus!.unfocus();
  }

  // get keyboardIsVisible {
  //   return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  // }

  void _addValuesRequest() {
    int _error = Provider.of<DataProvider>(context, listen: false)
        .addMoreValues(_controllerX.text, _controllerY.text);
    if (_error == 0) {
      _clearControllers();
      FocusManager.instance.primaryFocus!.unfocus();
      _scrollDown();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              MyTranslations().getLocale(
                  Provider.of<DataProvider>(_context, listen: false)
                      .getLanguage(),
                  'warning'),
              textAlign: TextAlign.center,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 40.0,
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
    }
  }

  void _clearControllers() {
    _controllerX.clear();
    _controllerY.clear();
  }

  // bool _changePow(bool yFlag, int value) {
  //   bool res = false;
  //   if (yFlag) {
  //     if((_yPow + value).abs() <= powLimit) {
  //       _yPow += value;
  //       res = true;
  //     }
  //   } else {
  //     if((_xPow + value).abs() <= powLimit) {
  //       _xPow += value;
  //       res = true;
  //     }
  //   }
  //   return res;
  // }

  void _clearData() {
    if (Provider.of<DataProvider>(context, listen: false).getValuesLength() > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            title: Text(
              MyTranslations().getLocale(
                  Provider.of<DataProvider>(_context, listen: false)
                      .getLanguage(),
                  'reset'),
              textAlign: TextAlign.center,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  MyTranslations().getLocale(
                      Provider.of<DataProvider>(_context, listen: false)
                          .getLanguage(),
                      'del_approve'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context),
                      child: SubscribedIconButton(
                        text: MyTranslations().getLocale(
                            Provider.of<DataProvider>(context, listen: false)
                                .getLanguage(),
                            'cancel'),
                        iconData: Icons.cancel_outlined,
                        iconColor: Colors.grey,
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Provider.of<DataProvider>(context, listen: false)
                            .clearAllData();
                        Navigator.pop(context);
                      },
                      child: SubscribedIconButton(
                        text: MyTranslations().getLocale(
                            Provider.of<DataProvider>(context, listen: false)
                                .getLanguage(),
                            'delete'),
                        iconData: Icons.delete,
                        iconColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
