import 'package:flutter/material.dart';
import 'package:least_squares/elements/value_text.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../styles_and_presets.dart';

// ignore: must_be_immutable
class ValuesPair extends StatelessWidget{
  int pairIndex;
  // double _dragStartX;
  ValuesPair({@required this.pairIndex});
  @override
  Widget build(BuildContext context){
    return Card(
      color: Provider.of<DataProvider>(context).theme.primaryColor,
      child: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details){
          //print('on start details: $details');
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          //print('on end details: $details');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () => Provider.of<DataProvider>(context, listen: false)
                      .startEditValue(pairIndex)),
            ),
            Center(
              child: Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 100) / 2,
                    height: 40.0,
                    child: ValueText(text:
                    'X = ${Provider.of<DataProvider>(context, listen: false).getValue('x', pairIndex)}',
                        style: Presets.currrentValueStyle),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 100) / 2,
                    height: 40.0,
                    child: ValueText(text:
                    'Y = ${Provider.of<DataProvider>(context, listen: false).getValue('y', pairIndex)}',
                        style: Presets.currrentValueStyle),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => Provider.of<DataProvider>(context, listen: false)
                      .removeOneValue(pairIndex)),
            ),
          ],
        ),
      ),
    );
  }
}