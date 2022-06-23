import 'dart:math';

import 'package:flutter/material.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:least_squares/styles_and_presets.dart';
import 'package:least_squares/utils/string_utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PowForm extends StatefulWidget {
  final String flag;
  PowForm({@required this.flag});
  @override
  _PowFormState createState() => _PowFormState();
}

class _PowFormState extends State<PowForm> {
  // double _powStartY;
  @override
  Widget build(BuildContext context) {
    final ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    int powValue = Provider.of<DataProvider>(context).getPowValue(widget.flag);
    final _str = powValue == 0 ? '' : '0';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: Presets.MINIMUM_TAP_SIZE,
          height: Presets.MINIMUM_TAP_SIZE,
          child: Transform.rotate(
            angle: -pi / 2.0,
            child: GestureDetector(
                onTap: () {
                  if(Provider.of<DataProvider>(context,listen: false).changePowValue(
                      widget.flag, -1) == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(MyTranslations().getLocale(
                                  Provider.of<DataProvider>(context,
                                      listen: false)
                                      .getLanguage(),
                                  'pow_out_of_range'),),
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
                  else {
                    setState(() {});
                  }
                },
              child: Icon(
                Icons.arrow_drop_up,
                color: _themeData.primaryColor,
                size: Presets.MINIMUM_TAP_SIZE,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'x1$_str${StringUtils.getPowSuperscript(powValue)}',
            style: TextStyle(
              color: _themeData.primaryTextTheme.bodyText1.color,
              fontSize: 14.0,
            ),
          ),
        ),
        SizedBox(
          width: Presets.MINIMUM_TAP_SIZE,
          height: Presets.MINIMUM_TAP_SIZE,
          child: Transform.rotate(
            angle: pi / 2.0,
            child: GestureDetector(
              onTap: () {
                if(Provider.of<DataProvider>(context,listen: false).changePowValue(
                    widget.flag, 1) == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(MyTranslations().getLocale(
                                Provider.of<DataProvider>(context,
                                    listen: false)
                                    .getLanguage(),
                                'pow_out_of_range'),),
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
                else {
                  setState(() {});
                }
              },
              child: Icon(
                Icons.arrow_drop_up,
                color: _themeData.primaryColor,
                size: Presets.MINIMUM_TAP_SIZE,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
