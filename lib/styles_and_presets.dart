import 'package:flutter/material.dart';

class Presets{
  static const TEXT_SIZE_LARGE = 25.0;
  static const TEXT_SIZE_MIDDLE = 20.0;
  static const TEXT_SIZE_SMALL = 14.0;
  static const TEXT_SIZE_DEFAULT = 16.0;
  static const MINUTE_STEP = 5;
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(4.0);
  static final Color _textColorDefault = Color(0xff666666);
  static final headerColor = Colors.lightBlue;

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
    color: _textColorDefault,
  );

}