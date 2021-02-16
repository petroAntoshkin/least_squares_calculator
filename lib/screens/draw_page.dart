import 'package:flutter/material.dart';
import 'package:least_squares/data_provider.dart';
import 'package:least_squares/localization.dart';
import 'package:provider/provider.dart';

class DrawPage extends StatelessWidget{
  String _loc;
  @override
  Widget build(BuildContext context){
    int _len = Provider.of<DataProvider>(context).getValuesLenght();
    _loc = Provider.of<DataProvider>(context).getLocale();
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width*0.9,
          height: MediaQuery.of(context).size.width*0.9,
        ),
        Padding(
            padding: EdgeInsets.all(8.0),
          child: _len == 0 ?
          Text(MyLocalization().getLocale(_loc, 'nanData')) :
          Container(),
        ),
      ],
    );
  }
}