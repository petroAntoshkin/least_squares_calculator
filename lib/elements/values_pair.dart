import 'package:flutter/material.dart';
import 'package:least_squares/elements/value_text.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../styles_and_presets.dart';

// ignore: must_be_immutable
class ValuesPair extends StatelessWidget {
  final pairIndex;
  final baseSize = 40.0;

  // double _dragStartX;
  ValuesPair({@required this.pairIndex});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Provider.of<DataProvider>(context, listen: false).theme;
    return Card(
      color: Provider.of<DataProvider>(context).isDataEdited(pairIndex)
          ? themeData.focusColor : themeData.primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          edgeButton(
            context,
            iconData: Icons.delete_outline,
            callback: () => Provider.of<DataProvider>(context, listen: false)
                .removeOneValue(pairIndex),
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 100) / 2 -
                      baseSize / 2,
                  height: baseSize,
                  child: ValueText(
                      text:
                          'X = ${Provider.of<DataProvider>(context, listen: false).getValue('x', pairIndex)}',
                      style: Presets.currrentValueStyle),
                ),
                SizedBox(
                  width: baseSize,
                  height: baseSize,
                  child: IconButton(
                    icon: Icon(Icons.swap_horiz),
                    onPressed: () {
                      final _error =
                          Provider.of<DataProvider>(context, listen: false)
                              .swapData(pairIndex);
                      if (_error > 0) {
                        debugPrint('unsuccess swap');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                MyTranslations().getLocale(
                                    Provider.of<DataProvider>(context,
                                            listen: false)
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
                                            Provider.of<DataProvider>(context,
                                                    listen: false)
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
                    },
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 100) / 2 -
                      baseSize / 2,
                  height: baseSize,
                  child: ValueText(
                      text:
                          'Y = ${Provider.of<DataProvider>(context, listen: false).getValue('y', pairIndex)}',
                      style: Presets.currrentValueStyle),
                ),
              ],
            ),
          ),
          edgeButton(
            context,
            iconData: Icons.edit_outlined,
            callback: () => Provider.of<DataProvider>(context, listen: false)
                .startEditValue(pairIndex),
          ),
        ],
      ),
    );
  }

  Widget edgeButton(BuildContext context,
      {@required IconData iconData, @required Function callback}) {
    final ThemeData themeData =
        Provider.of<DataProvider>(context, listen: false).theme;
    return SizedBox(
      width: baseSize,
      height: baseSize,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: Presets.defaultBorderRadius,
          color: themeData.primaryColor,
        ),
        child: IconButton(
          icon: Icon(iconData),
          onPressed: callback,
        ),
      ),
    );
  }
}
