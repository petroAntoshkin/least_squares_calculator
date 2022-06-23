import 'package:flutter/material.dart';
import 'package:least_squares/elements/language_card.dart';
import 'package:least_squares/elements/theme_card.dart';
import 'package:least_squares/mocks/lang_mock.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/mocks/themes_mock.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

// import 'package:least_squares/providers/data_provider.dart';
// import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  LanguagesMock _langMap = new LanguagesMock();

  @override
  Widget build(BuildContext context) {
    var _settingsLV = ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Text(
            MyTranslations().getLocale(
                Provider.of<DataProvider>(context, listen: false).getLanguage(),
                'language'),
            style: TextStyle(
                fontSize: 16.0,
                color: Provider.of<DataProvider>(context, listen: false)
                    .theme
                    .indicatorColor),
          ),
        ),
        Divider(thickness: 2.0),
        for (int i = 0; i < _langMap.languges.length; i++)
          LanguageCard(languageModel: _langMap.languges[i]),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10, left: 10),
          child: Text(
            MyTranslations().getLocale(
                Provider.of<DataProvider>(context, listen: false).getLanguage(),
                'theme'),
            style: TextStyle(
                fontSize: 16.0,
                color: Provider.of<DataProvider>(context, listen: false)
                    .theme
                    .indicatorColor),
          ),
        ),
        Divider(thickness: 2.0),
        for (int i = 0; i < ThemesMock().themes.length; i++)
          ThemeCard(
            index: i,
          ),
      ],
    );
    return _settingsLV;
    // return ListView.builder(
    //       itemBuilder: langItemBuilder,
    //       itemCount: _langMap.languges.length,
    // );
  }

  Widget langItemBuilder(BuildContext context, int index) {
    return LanguageCard(languageModel: _langMap.languges[index]);
  }
}
