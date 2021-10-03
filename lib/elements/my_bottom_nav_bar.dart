import 'package:flutter/material.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  final List<IconData> _icons = [Icons.cleaning_services, Icons.image, Icons.delete, Icons.settings_outlined];
  final List<String> _texts = ['reset', 'export', 'delete', 'default_settings'];
  int tabIndex;
  final _buttonSize = 40.0;
  MyBottomNavBar({this.tabIndex});
  @override
  Widget build(BuildContext context) {
    // final _height = MediaQuery.of(context).size.height * 0.14 + bannerHeight;
    final _width = MediaQuery.of(context).size.width;
    ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    // Provider.of<DataProvider>(context).navBarHe = _buttonSize;
    Widget _gestureBlock(){
      return Container(
        child: GestureDetector(
          onTap: () => Provider.of<DataProvider>(context, listen: false).contextFunctions(tabIndex),
          child: Container(
            color: _themeData.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: _buttonSize,
                  height: _buttonSize,
                  child: Center(
                    child: Icon(
                      _icons[tabIndex],
                      color: _themeData.primaryTextTheme.bodyText1.color,
                    ),
                  ),
                ),
                SizedBox(
                  width: _width - _buttonSize * 3,
                  height: _buttonSize,
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
                  width: _buttonSize,
                  height: _buttonSize,
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
      );
    }
    return SizedBox(
      width: _width,
      height: _buttonSize,
      child: _gestureBlock(),
    );
  }
}
