import 'package:flutter/material.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:least_squares/utils/string_utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PowForm extends StatefulWidget {
  bool leftFlag;
  int powValue;
  Function callback;
  PowForm({@required this.leftFlag, @required this.powValue, @required this.callback});
  @override
  _PowFormState createState() => _PowFormState();
}

class _PowFormState extends State<PowForm> {
  double _powStartY;
  @override
  Widget build(BuildContext context) {
    final ThemeData _themeData = Provider.of<DataProvider>(context).theme;
    final _str = widget.powValue == 0 ? '' : '0';
    return Container(
      decoration: BoxDecoration(
        color: _themeData.primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(widget.leftFlag ? 0.0 : 10.0),
          topLeft: Radius.circular(widget.leftFlag ? 10.0 : 0.0),
        ),
      ),
      child: SizedBox(
        height: 34.0,
        width: MediaQuery.of(context).size.width / 4,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'x1$_str${StringUtils.getPowSuperscript(widget.powValue)}',
                style: TextStyle(
                  color: _themeData.primaryTextTheme.bodyText1.color,
                  fontSize: 14.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.arrow_drop_up,
                color: _themeData.primaryTextTheme.bodyText1.color,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_drop_down,
                color: _themeData.primaryTextTheme.bodyText1.color,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () => _changePow(1),
                onScaleStart: (ScaleStartDetails details) => _powStartY = details.localFocalPoint.dy,
                onScaleUpdate: (ScaleUpdateDetails details) =>
                    _changePow((_powStartY-details.localFocalPoint.dy ) ~/ 40),
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: 0.5,
                  child: Container(color: Color(0x00ff0000)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => _changePow(-1),
                onScaleStart: (ScaleStartDetails details) => _powStartY = details.localFocalPoint.dy,
                onScaleUpdate: (ScaleUpdateDetails details) =>
                    _changePow((_powStartY-details.localFocalPoint.dy ) ~/ 40),
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  heightFactor: 0.5,
                  child: Container(color: Color(0x000000ff)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePow(int value) {
    widget.callback(widget.leftFlag, value);
    setState(() {widget.powValue += value;});
  }
}
