import 'package:flutter/material.dart';
import 'package:least_squares/providers/data_provider.dart';
import 'package:provider/provider.dart';

typedef IntValue = void Function(int);


// ignore: must_be_immutable
class DropDownList extends StatefulWidget {
  Map<int, String> itemsList;
  int currentValue;
  IntValue callBack;
  _DropDownListState listState;

  DropDownList(
      {Key key, @required this.itemsList, this.currentValue, this.callBack})
      : super(key: key);

  @override
  _DropDownListState createState() {
    listState = _DropDownListState(itemsList: itemsList, currentValue: currentValue, callBack: callBack);
    return listState;
  }

  void rebuildList(Map<int, String> itemsList){
    // print('update list ${listState.itemsList}');
    listState._updateList(itemsList);
  }
}

/// This is the private State class that goes with DropDownList.
class _DropDownListState extends State<DropDownList> {
  Map<int, String> itemsList;
  IntValue callBack;
  int currentValue;
  ThemeData _themeData;

  _DropDownListState(
      {@required this.itemsList, this.currentValue, this.callBack});

  Map<int, String> _dropdownItems = new Map<int, String>();

  int _selectedItem;

  void initState() {
    super.initState();
    if (currentValue == null) currentValue = 0;
    itemsList.forEach((key, value) {_dropdownItems.putIfAbsent(key, () => value);});
    // _themeData = Provider.of<DataProvider>(context).theme;
    _selectedItem = buildDropDownMenuItems(_dropdownItems)[currentValue].value;
  }

  List<DropdownMenuItem> buildDropDownMenuItems(Map<int, String> listItems) {
    List<DropdownMenuItem> items = [];
    listItems.forEach((key, value) {
      items.add(DropdownMenuItem(child: Text(
        value,
        style: TextStyle(
          color: _themeData != null ? _themeData.primaryTextTheme.bodyText1.color : Colors.white54,
        ),
      ), value: key,));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Provider.of<DataProvider>(context).theme;
    // print('build list ${this.itemsList.length}');
    return Container(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: DropdownButton(
          dropdownColor: _themeData.backgroundColor,
            value: _selectedItem,
            items: buildDropDownMenuItems(_dropdownItems),
            onChanged: (value) {
              setState(() {
                _selectedItem = value;
                widget.currentValue = _selectedItem;
                widget.callBack(widget.currentValue);
              });
            }),
      ),
    );
  }

  void _updateList(Map<int, String> _itemsList){
    setState(() {
      this.itemsList = _itemsList;
      _dropdownItems = new Map();
      this.itemsList.forEach((key, value) {_dropdownItems.putIfAbsent(key, () => value);});
      _selectedItem = buildDropDownMenuItems(_dropdownItems)[currentValue].value;
    });
  }

}

