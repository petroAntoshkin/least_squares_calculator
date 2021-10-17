import 'package:flutter/material.dart';
import 'package:least_squares/elements/value_text.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../mocks/my_translations.dart';
import '../styles_and_presets.dart';

class AppbarTitle extends StatelessWidget {
  final ThemeData themeData;

  AppbarTitle({@required this.themeData});

  @override
  Widget build(BuildContext context) {
    final String _loc = Provider.of<DataProvider>(context).getLanguage();
    final double _valueWidth = MediaQuery.of(context).size.width * 0.4;
    final String _aValue = Provider.of<DataProvider>(context).getAString();
    final String _bValue = Provider.of<DataProvider>(context).getBString();
    final _textStyle = TextStyle(
      fontSize: 18,
      color: themeData.primaryTextTheme.bodyText1.color,
    );
    return Container(
      // color: Colors.red,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 2,),
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: _loc != null
                ? Text(
                    MyTranslations().getLocale(_loc, 'title'),
                    style: _textStyle,
                  )
                : Text(
                    'Least Squares Calculator',
                    style: _textStyle,
                  ),
          ),
          SizedBox(
            height: 3.0,
          ),
          Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: themeData.primaryColor.withAlpha(80),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: _valueWidth,
                  child: _loc != null
                      ? ValueText(
                          text: _aValue, style: Presets.resultsValueStyle)
                      : Container(),
                ),
                //Expanded(child: Container()),
                SizedBox(
                  width: _valueWidth,
                  child: _loc != null
                      ? ValueText(
                          text: _bValue, style: Presets.resultsValueStyle)
                      : Container(),
                ),
                InkWell(
                  onTap: () {
                    final String _res = '$_aValue $_bValue';
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
                    color: themeData.primaryTextTheme.bodyText1.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
