import 'package:flutter/material.dart';
import 'package:least_squares/elements/my_radio_button.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ThemeCard extends StatelessWidget {
  ThemeData _themeData;
  int index;
  ThemeCard({this.index});
  @override
  Widget build(BuildContext context) {
    _themeData = Provider.of<DataProvider>(context).getThemeModelById(index).data;
    if(_themeData == null)
      _themeData = ThemeData();
    return Container(
      child: Card(
        color: _themeData.backgroundColor,
        child: GestureDetector(
          onTap: () => Provider.of<DataProvider>(context, listen: false).changeTheme(index),
          child: Container(
            color: Color(0x00ffffff),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  SizedBox(width: 30, height: 20, child: Container(color: _themeData.primaryColor,),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                        Provider.of<DataProvider>(context).getThemeModelById(index).name,
                      style: _themeData.primaryTextTheme.bodyText1,
                    ),
                  ),
                  Expanded(child: Container()),
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: MyRadioButton(isSelected: Provider.of<DataProvider>(context,listen: false).themeId == index),
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
