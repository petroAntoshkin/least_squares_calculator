import 'package:flutter/material.dart';

class Presets{
  static const TEXT_SIZE_LARGE = 25.0;
  static const TEXT_SIZE_MIDDLE = 20.0;
  static const TEXT_SIZE_SMALL = 14.0;
  static const TEXT_SIZE_DEFAULT = 16.0;
  static const MINUTE_STEP = 5;
  static const LINE_WIDTH = 30.0;
  static const SETTINGS_CARD_HEIGHT = 36.0;
  static const DOT_SIZE = 10.0;
  static const ARC_SIZE = 8.0;
  static const MINIMUM_TAP_SIZE = 40.0;
  static const RESULTS_BAR_HEIGHT = 60.0;
  static const APP_BAR_HEIGHT = 60.0;
  static const NAV_BAR_HEIGHT = 54.0;
  // static const COLLAPSED_SETTINGS_BAR_HEIGHT = 86.0;
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(4.0);
  static final headerColor = Colors.lightBlue;
  // static final numberRegExp = RegExp(r'^\-?\d*\.?\d*');
  static final numberRegExp = RegExp(r'^\-?\d*[,.]?\d*');

  static final String _fontNameDefault = 'Verdana';

  static final prevPrevValueStyle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: TEXT_SIZE_MIDDLE,
    color: Color(0x44000000),
  );
  static final prevValueStyle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: TEXT_SIZE_DEFAULT,
    color: Color(0x99000000),
  );

  static final currrentValueStyle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: TEXT_SIZE_DEFAULT,
    color: Color(0xff000000),
  );
  static final resultsValueStyle = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: TEXT_SIZE_LARGE,
    fontWeight: FontWeight.bold,
    color: Color(0xff000000),

  );

  static final textSmall = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: TEXT_SIZE_SMALL,
    // color: _textColorDefault,
  );

}