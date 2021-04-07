import 'package:flutter/material.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  final List<IconData> _icons = [Icons.cleaning_services, Icons.image, Icons.delete, Icons.settings_outlined];
  final List<String> _texts = ['reset', 'export', 'delete', 'default_settings'];
  int tabIndex;
  MyBottomNavBar({this.tabIndex});
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height * 0.085;
    ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: _height,
      child: Container(

        child: GestureDetector(
          onTap: () => Provider.of<DataProvider>(context, listen: false).contextFunctions(tabIndex),
          child: Container(
            color: _themeData.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: _height,
                  height: _height,
                  child: Center(
                    child: Icon(
                      _icons[tabIndex],
                      color: _themeData.primaryTextTheme.bodyText1.color,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - _height * 3,
                  height: _height,
                  child: Center(
                    child: Text(
                      MyTranslations().getLocale(
                          Provider.of<DataProvider>(context).getLanguage(),
                          _texts[tabIndex]),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                        _themeData.primaryTextTheme.bodyText1.color,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _height,
                  height: _height,
                  child: Center(
                    child: Icon(
                      _icons[tabIndex],
                      color: _themeData.primaryTextTheme.bodyText1.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
