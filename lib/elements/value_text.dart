import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ValueText extends StatelessWidget{
  String text;
  TextStyle style;
  ValueText({@required this.text, this.style});
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(text,)
            ),
          )),
    );
  }
}