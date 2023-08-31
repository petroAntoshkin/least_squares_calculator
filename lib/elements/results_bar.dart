import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:least_squares_calculator/elements/value_text.dart';
import 'package:least_squares_calculator/mocks/my_translations.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';
import 'package:provider/provider.dart';

class ResultBar extends StatelessWidget {
  const ResultBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _dataCount = Provider.of<DataProvider>(context).dataLength();
    final String _loc = Provider.of<DataProvider>(context).getLanguage();
    final double _valueWidth = (MediaQuery.of(context).size.width - Presets.MINIMUM_TAP_SIZE) / 2;
    final String _aValue = Provider.of<DataProvider>(context).getAString();
    final String _aDeviation =
        Provider.of<DataProvider>(context).getADeviationString();
    final String _bValue = Provider.of<DataProvider>(context).getBString();
    final String _bDeviation =
        Provider.of<DataProvider>(context).getBDeviationString();
    final ThemeData themeData = Provider.of<DataProvider>(context).theme;
    const double valueSizeMultiplier = 0.94;

    return SizedBox(
      height: Presets.RESULTS_BAR_HEIGHT,
      width: MediaQuery.of(context).size.width,
      child: Container(
        // padding: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: themeData.primaryColor,
        ),
        child: _dataCount < 2
            ? Center(
                child: _loc != null
                    ? ValueText(
                        text: MyTranslations().getLocale(_loc, _dataCount == 0 ? 'nanData' : 'nanMessage'),
                        style: Presets.resultsValueStyle)
                    : Container(),
              )
            : Row(
                children: [
                  SizedBox(
                    width: _valueWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: _valueWidth * valueSizeMultiplier,
                          child: _loc != null
                              ? ValueText(
                                  text: _aValue,
                                  style: Presets.resultsValueStyle)
                              : Container(),
                        ),
                        _dataCount < 3
                            ? Container()
                            : SizedBox(
                                width: _valueWidth * valueSizeMultiplier,
                                child: _loc != null
                                    ? ValueText(
                                        text: _aDeviation,
                                        style: Presets.resultsValueStyle)
                                    : Container(),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Presets.MINIMUM_TAP_SIZE,
                    height: Presets.MINIMUM_TAP_SIZE,
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
                        color: themeData.focusColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _valueWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: _valueWidth * valueSizeMultiplier,
                          child: _loc != null
                              ? ValueText(
                                  text: _bValue,
                                  style: Presets.resultsValueStyle)
                              : Container(),
                        ),
                        _dataCount < 3
                            ? Container()
                            : SizedBox(
                                width: _valueWidth * valueSizeMultiplier,
                                child: _loc != null
                                    ? ValueText(
                                        text: _bDeviation,
                                        style: Presets.resultsValueStyle)
                                    : Container(),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
