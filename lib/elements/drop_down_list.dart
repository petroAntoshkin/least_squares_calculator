import 'package:flutter/material.dart';
import 'package:least_squares_calculator/models/named_widget.dart';
import 'dart:core';

typedef IntValue = void Function(int);

// ignore: must_be_immutable
class DropDownList extends StatefulWidget {
  Map<int, NamedWidget> itemsList;
  int currentValue;
  IntValue callBack;
  _DropDownListState listState = _DropDownListState(itemsList: {}, currentValue: 0, callBack: (int ) {  },);

  DropDownList(
      {Key? key, required this.itemsList, required this.currentValue, required this.callBack})
      : super(key: key);

  @override
  _DropDownListState createState() {
    listState = _DropDownListState(
        itemsList: itemsList, currentValue: currentValue, callBack: callBack);
    return listState;
  }

  void rebuildList(Map<int, NamedWidget> itemsList) {
    // debugPrint('update list ${listState.itemsList}');
    listState._updateList(itemsList);
  }
}

/// This is the private State class that goes with DropDownList.
class _DropDownListState extends State<DropDownList> {
  Map<int, NamedWidget> itemsList;
  IntValue callBack;
  int currentValue;
  // ThemeData _themeData = ThemeData();

  _DropDownListState(
      {required this.itemsList, required this.currentValue, required this.callBack});

  // List<DropdownMenuItem<int>> _dropdownItemsList = [];
  Map<int, NamedWidget> _dropdownItems = new Map<int, NamedWidget>();

  int _selectedItem = 0;

  void initState() {
    super.initState();
    // if (currentValue == null) currentValue = 0;
    itemsList.forEach((key, value) {
      _dropdownItems.putIfAbsent(key, () => value);
    });
    // _themeData = Provider.of<DataProvider>(context).theme;
    _selectedItem = buildDropDownMenuItems(_dropdownItems)[currentValue].value!;
  }

  List<DropdownMenuItem<int>> buildDropDownMenuItems(Map<int, NamedWidget> listItems) {
    List<DropdownMenuItem<int>> items = [];
    listItems.forEach((key, value) {
      items.add(DropdownMenuItem(
        child: value.widget,
        value: key,
      ));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // _themeData = Provider.of<DataProvider>(context).theme;
    // print('build list ${this.itemsList.length}');
    return Container(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: DropdownButton<int>(
          value: _selectedItem,
          icon: const Icon(Icons.arrow_drop_down, size: 30.0,),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (int? value) {
            // This is called when the user selects an item.
            callBack(value!);
            setState(() {
              _selectedItem = value;
            });
          },
          items: buildDropDownMenuItems(_dropdownItems),
        ),
        // DropdownButton(
        //     //underline: SizedBox(child: Container(color: Colors.red,),),
        //     dropdownColor: _themeData.primaryColor,
        //     iconEnabledColor: _themeData.primaryTextTheme.bodyLarge?.color,
        //     value: _selectedItem,
        //     items: buildDropDownMenuItems(_dropdownItems),
        //     onChanged: (value) {
        //       setState(() {
        //         _selectedItem = value as int;
        //         widget.currentValue = _selectedItem;
        //         widget.callBack(widget.currentValue);
        //       });
        //     }),
      ),
    );
  }

  void _updateList(Map<int, NamedWidget> _itemsList) {
    setState(() {
      this.itemsList = _itemsList;
      _dropdownItems = new Map();
      this.itemsList.forEach((key, value) {
        _dropdownItems.putIfAbsent(key, () => value);
      });
      _selectedItem =
          buildDropDownMenuItems(_dropdownItems)[currentValue].value!;
    });
  }
}
