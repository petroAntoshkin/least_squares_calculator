import 'package:flutter/material.dart';
import 'package:least_squares_calculator/elements/value_text.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../mocks/my_translations.dart';
import '../styles_and_presets.dart';

class AppbarTitle extends StatelessWidget {
  final ThemeData themeData;

  AppbarTitle({required this.themeData});

  @override
  Widget build(BuildContext context) {
    final int _dataCount = Provider.of<DataProvider>(context).dataLength();
    final String _loc = Provider.of<DataProvider>(context).getLanguage();
    final double _valueWidth = MediaQuery.of(context).size.width * 0.4;
    final String _aValue = Provider.of<DataProvider>(context).getAString();
    final String _aDeviation =
        Provider.of<DataProvider>(context).getADeviationString();
    final String _bValue = Provider.of<DataProvider>(context).getBString();
    final String _bDeviation =
        Provider.of<DataProvider>(context).getBDeviationString();
    // final _textStyle = TextStyle(
    //   fontSize: 18,
    //   color: themeData.primaryTextTheme.bodyText1.color,
    // );
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: themeData.primaryColor,
      ),
      child: _dataCount < 2
          ? Center(
              child: _loc != null
                  ? ValueText(text: MyTranslations()
                  .getLocale(_loc, 'title'), style: Presets.resultsValueStyle)
                  : Container(),
            )
          : Row(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: _valueWidth,
                          child: _loc != null
                              ? ValueText(
                                  text: _aValue,
                                  style: Presets.resultsValueStyle)
                              : Container(),
                        ),
                        //Expanded(child: Container()),
                        SizedBox(
                          width: _valueWidth,
                          child: _loc != null
                              ? ValueText(
                                  text: _bValue,
                                  style: Presets.resultsValueStyle)
                              : Container(),
                        ),
                      ],
                    ),
                    _dataCount < 3
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: _valueWidth,
                                child: _loc != null
                                    ? ValueText(
                                        text: _aDeviation,
                                        style: Presets.resultsValueStyle)
                                    : Container(),
                              ),
                              //Expanded(child: Container()),
                              SizedBox(
                                width: _valueWidth,
                                child: _loc != null
                                    ? ValueText(
                                        text: _bDeviation,
                                        style: Presets.resultsValueStyle)
                                    : Container(),
                              ),
                            ],
                          ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      final String _res =
                          '$_aValue $_bValue $_aDeviation $_bDeviation';
                      Clipboard.setData(ClipboardData(text: _res));
                      debugPrint(_res);
                      final snackBar = SnackBar(
                        content: Text(
                          MyTranslations()
                              .getLocale(_loc, 'copy_success_message'),
                        ),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Icon(
                      Icons.copy,
                      color: themeData.indicatorColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
