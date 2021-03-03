import 'package:flutter/material.dart';
import 'package:least_squares/elements/language_card.dart';
import 'package:least_squares/mocks/lang_mock.dart';
// import 'package:least_squares/providers/data_provider.dart';
// import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget{
  LanguagesMock _langMap = new LanguagesMock();
  @override
  Widget build(BuildContext context){
    // String _loc = Provider.of<DataProvider>(context).getLocale();
    // Text(MyTranslations().getLocale(Provider.of<DataProvider>(context).getLocale(), 'settings')),
    return ListView.builder(
          itemBuilder: langItemBuilder,
          itemCount: _langMap.languges.length,
    );
  }

  Widget langItemBuilder(BuildContext context, int index){
    return LanguageCard(languageModel: _langMap.languges[index]);
  }

}