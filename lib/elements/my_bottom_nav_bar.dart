import 'package:flutter/material.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';

import 'bottom_nav_painter.dart';

class MyBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.width * 0.08),
        painter: BottomNavPainter(color: _themeData.primaryColor),
        // ignore: deprecated_member_use
        child: FlatButton(
          onPressed: ()=> Dialogs.bottomMaterialDialog(
              msg: MyTranslations().getLocale(
                  Provider.of<DataProvider>(context, listen: false).getLocale(), 'del_approve'),
              title: MyTranslations().getLocale(
                  Provider.of<DataProvider>(context, listen: false).getLocale(), 'reset'),
              context: context,
              actions: [
                IconsOutlineButton(
                  onPressed: () => Navigator.pop(context),
                  text: MyTranslations().getLocale(
                      Provider.of<DataProvider>(context, listen: false).getLocale(), 'cancel'),
                  iconData: Icons.cancel_outlined,
                  textStyle: TextStyle(color: Colors.grey),
                  iconColor: Colors.grey,
                ),
                IconsButton(
                  onPressed: () {
                    Provider.of<DataProvider>(context, listen: false).clearAllData();
                    Navigator.pop(context);
                  },
                  text: MyTranslations().getLocale(
                      Provider.of<DataProvider>(context, listen: false).getLocale(), 'delete'),
                  iconData: Icons.delete,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]),
          // onPressed: () => Provider.of<DataProvider>(context, listen: false)
          //     .clearAllData(),
          child: Container(
            // color: Colors.green,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.height * 0.07,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Icon(
                      Icons.cleaning_services,
                      color: _themeData.primaryTextTheme.bodyText1.color,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    MyTranslations().getLocale(
                        Provider.of<DataProvider>(context).getLocale(),
                        'reset'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _themeData.primaryTextTheme.bodyText1.color,
                    ),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.height * 0.07,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Icon(
                      Icons.cleaning_services,
                      color: _themeData.primaryTextTheme.bodyText1.color,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
