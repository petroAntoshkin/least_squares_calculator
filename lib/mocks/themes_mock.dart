import 'package:flutter/material.dart';
import 'package:least_squares/models/theme_list_model.dart';

class ThemesMock {
  // Color _hexToColor(String code) {
  //   return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  // }

  final Map<int, ThemeListModel> themes = Map();

  ThemesMock() {
    themes[0] = ThemeListModel(
        name: 'Default',
        data: ThemeData(
          primaryColor: Color(0xff9E9E9E),
          primaryColorDark: Color(0xff707070),
          primaryColorLight: Color(0xffCFCFCF),
          focusColor: Color(0xffFFD600),
          backgroundColor: Color(0xffF0F0F0),
          indicatorColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
          // backgroundColor: _hexToColor('BFADA3'),
        ));
    themes[1] = ThemeListModel(
        name: 'Dark green',
        data: ThemeData(
          primaryColor: Color(0xff494d43),
          primaryColorDark: Color(0xff292c27),
          primaryColorLight: Color(0xff717a6e),
          focusColor: Color(0xffbaef8a),
          backgroundColor: Color(0xff1c1c1c),
          indicatorColor: Colors.white,
          primaryTextTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.black)
          ),
          // colorScheme:
          //     ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
        ));
    themes[2] = ThemeListModel(
        name: 'Dark',
        data: ThemeData(
          primaryColorDark: Color(0xff9E9E9E),
          primaryColorLight: Color(0xff707070),
          primaryColor: Color(0xffCFCFCF),
          focusColor: Color(0xffFFD600),
          backgroundColor: Colors.black,
          indicatorColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
          // backgroundColor: _hexToColor('BFADA3'),
        ));
  }
}

/*

/* Default    */
.Wilderness-1-hex { color: #D9D7D7; }
.Wilderness-2-hex { color: #010D00; }
.Wilderness-3-hex { color: #BFAB49; }
.Wilderness-4-hex { color: #8C7B6C; }
.Wilderness-5-hex { color: #BFADA3; }

/* Dark green    */
.Graphic-Design-1-hex { color: #54594D; }
.Graphic-Design-2-hex { color: #3D403A; }
.Graphic-Design-3-hex { color: #BFB8AE; }
.Graphic-Design-4-hex { color: #D9D1C7; }
.Graphic-Design-5-hex { color: #262626; }

/* Black and white */
.Wilderness-1-hex { color: #202426; }
.Wilderness-2-hex { color: #6C733D; }
.Wilderness-3-hex { color: #9DA65D; }
.Wilderness-4-hex { color: #8C8C88; }
.Wilderness-5-hex { color: #F2F2F2; }


*/

/* Color Theme Swatches in Hex

5D7CA6
023059
03588C
73A2BF
F2CAA7

*/
