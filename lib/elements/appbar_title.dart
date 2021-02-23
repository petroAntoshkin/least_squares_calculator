import 'package:flutter/material.dart';
import 'package:least_squares/elements/value_text.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../my_translations.dart';
import '../styles_and_presets.dart';

class AppbarTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final String _loc = Provider.of<DataProvider>(context).getLocale();
    return Container(
      // color: Colors.red,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8,),
          _loc != null ? Text(MyTranslations().getLocale(_loc, 'title')) : Text('Least Squares Calculator'),
          Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.45,
                child: _loc != null ? ValueText(text: Provider.of<DataProvider>(context).getA(),
                    style: Presets.resultsValueStyle) : Container(),
              ),
              Expanded(child: Container()),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.45,
                child: _loc != null ? ValueText(text: Provider.of<DataProvider>(context).getB(),
                    style: Presets.resultsValueStyle) : Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}