import 'package:flutter/material.dart';
import 'package:least_squares/elements/my_radio_button.dart';
import 'package:least_squares/models/language_model.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class LanguageCard extends StatelessWidget {
  LanguageModel languageModel;

  LanguageCard({this.languageModel});

  @override
  Widget build(BuildContext context) {
    if (languageModel == null) {
      languageModel = new LanguageModel(prefix: 'en', name: 'English');
    }
    ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    bool _thisLangIsCurrent =
        Provider.of<DataProvider>(context).getLocale() == languageModel.prefix;
    String _name = 'assets/flags/flag_${languageModel.prefix}.png';
    return Container(
      child: Card(
        color: _themeData.primaryColor,
        child: GestureDetector(
          onTap: () => Provider.of<DataProvider>(context, listen: false)
              .changeLocale(languageModel.prefix),
          child: Container(
            color: Color(0x00ffffff),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  SizedBox(width: 30, height: 20, child: Image.asset(_name)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(languageModel.name, style: _themeData.primaryTextTheme.bodyText1,),
                  ),
                  Expanded(child: Container()),
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: MyRadioButton(isSelected: _thisLangIsCurrent),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
