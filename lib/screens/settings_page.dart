import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:least_squares_calculator/elements/language_card.dart';
import 'package:least_squares_calculator/elements/theme_card.dart';
import 'package:least_squares_calculator/mocks/lang_mock.dart';
import 'package:least_squares_calculator/mocks/my_translations.dart';
import 'package:least_squares_calculator/mocks/themes_mock.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';
import 'package:provider/provider.dart';

// import 'package:least_squares_calculator/providers/data_provider.dart';
// import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LanguagesMock _langMap = new LanguagesMock();
  final Map<String, bool> _collapsed = { 'language': false, 'themes': false, 'sort': false};
  // List<bool> _collapsed = [false, false, false];
  late DataProvider _data;

  @override
  Widget build(BuildContext context) {
    _data = Provider.of<DataProvider>(context);

    return ListView(
      children: <Widget>[
        _settingsHeader(context, 'language', 'language'),
        Divider(thickness: 2.0),
        for (int i = 0; i < _langMap.languges.length && !_collapsed['language']!; i++)
          LanguageCard(languageModel: _langMap.languges[i]!),
        _settingsHeader(context, 'theme', 'themes'),
        Divider(thickness: 2.0),
        for (int i = 0; i < ThemesMock().themes.length && !_collapsed['themes']!; i++)
          ThemeCard(
            index: i,
          ),
        _settingsHeader(context, 'misc', 'sort'),
        Divider(thickness: 2.0),
        _collapsed['sort']!
            ? Container()
            : Card(
                color: _data.theme.colorScheme.background,
                child: GestureDetector(
                  onTap: () {
                    _data.toggleSorting();
                    setState(() {});
                  },
                  child: Container(
                    color: Color(0x00ffffff),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: Presets.SETTINGS_CARD_HEIGHT,
                          ),
                          Text(
                            MyTranslations()
                                .getLocale(_data.getLanguage(), 'sortDataOnX'),
                            style: TextStyle(color: _data.theme.indicatorColor),
                          ),
                          Expanded(child: Container()),
                          SizedBox(
                            width: 40.0,
                            height: 20.0,
                            child: Icon(_data.sortByX
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank,
                              color: _data.theme.indicatorColor,
                            ),
                            // child: MyRadioButton(isSelected: Provider.of<DataProvider>(context,listen: false).themeId == index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
    // return _settingsLV;
    // return ListView.builder(
    //       itemBuilder: langItemBuilder,
    //       itemCount: _langMap.languges.length,
    // );
  }

  Widget langItemBuilder(BuildContext context, int index) {
    return LanguageCard(languageModel: _langMap.languges[index]!);
  }

  Widget _settingsHeader(BuildContext context, String text, String collapseIndex) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 10,
        left: 10,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            MyTranslations().getLocale(
                Provider.of<DataProvider>(context, listen: false).getLanguage(),
                text),
            style: TextStyle(
                fontSize: 16.0,
                color: Provider.of<DataProvider>(context, listen: false)
                    .theme
                    .indicatorColor),
          ),
          SizedBox(
            width: 40.0,
            height: 40.0,
            child: InkWell(
              onTap: () =>
                setState(() {
                  _collapsed[collapseIndex] = !_collapsed[collapseIndex]!;
                }),
              child: Center(
                child: Icon(
                  _collapsed[collapseIndex]!
                      ? Icons.arrow_drop_down_outlined
                      : Icons.arrow_drop_up_outlined,
                  size: 34.0,
                  color: Provider.of<DataProvider>(context).theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
