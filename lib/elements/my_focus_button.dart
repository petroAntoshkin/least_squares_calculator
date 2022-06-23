import 'package:flutter/material.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:least_squares/styles_and_presets.dart';
import 'package:provider/provider.dart';

class MyFocusButton extends StatelessWidget {

  final Function callback;
  final String text;

  const MyFocusButton({Key key, this.callback, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Presets.MINIMUM_TAP_SIZE,
      width: Presets.MINIMUM_TAP_SIZE * 2,
      child: GestureDetector(
        child: SizedBox(
          width: Presets.MINIMUM_TAP_SIZE * 2,
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 8.0),
            // color: Colors.red,
            decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Provider.of<DataProvider>(context,
              //         listen: false).theme.primaryColorLight,
              //     offset: const Offset(0, 2),
              //     blurRadius: 2,
              //     spreadRadius: 0,
              //   )
              // ],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
              color: Provider.of<DataProvider>(context,
                  listen: false).theme.focusColor,
              // border: Border.all(
              //     color: Colors.black54, width: 1.0),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.9,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  MyTranslations().getLocale(
                      Provider.of<DataProvider>(context,
                          listen: false)
                          .getLanguage(),
                      text),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        onTap: callback(),
      ),
    );
  }
}
