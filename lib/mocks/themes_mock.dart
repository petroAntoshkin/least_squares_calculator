import 'package:flutter/material.dart';
import 'package:least_squares/models/theme_list_model.dart';

class ThemesMock {

  Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
  
  final Map<int, ThemeListModel> themes = Map();

  ThemesMock() {
    themes[0] = ThemeListModel(
        name: 'Default',
        data: ThemeData(
          primaryColor: _hexToColor('D9D7D7'),
          primaryColorDark: _hexToColor('010D00'),
          accentColor: Colors.white,
          backgroundColor: _hexToColor('F0F0F0'),
          // backgroundColor: _hexToColor('BFADA3'),
        )
    );
    themes[1] = ThemeListModel(
        name: 'Dark green',
        data: ThemeData(
          primaryColor: _hexToColor('54594D'),
          primaryColorDark: _hexToColor('3D403A'),
          accentColor: Colors.white54,
          backgroundColor: _hexToColor('262626'),
        )
    );
    themes[2] = ThemeListModel(
        name: 'Black and white',
        data: ThemeData(
            primaryColor: _hexToColor('a6a6a6'),
            primaryColorDark: _hexToColor('f2f2f2'),
            accentColor: _hexToColor('0d0d0d'),
            backgroundColor: _hexToColor('555555'),
        )
    );
    /*themes[3] = ThemeListModel(
        name: 'X3',
        data: ThemeData(
            primaryColor: _hexToColor('5D7CA6'),
            primaryColorDark: _hexToColor('73A2BF'),
            accentColor: _hexToColor('03588C'),
            backgroundColor: _hexToColor('023059'),
        )
    );*/
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