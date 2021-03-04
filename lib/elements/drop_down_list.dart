import 'package:flutter/material.dart';

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

  _DropDownListState(
      {@required this.itemsList, this.currentValue, this.callBack});

  Map<int, String> _dropdownItems = new Map<int, String>();

  int _selectedItem;

  void initState() {
    super.initState();
    if (currentValue == null) currentValue = 0;
    itemsList.forEach((key, value) {_dropdownItems.putIfAbsent(key, () => value);});
    _selectedItem = buildDropDownMenuItems(_dropdownItems)[currentValue].value;
  }

  List<DropdownMenuItem> buildDropDownMenuItems(Map<int, String> listItems) {
    List<DropdownMenuItem> items = [];
    listItems.forEach((key, value) {
      items.add(DropdownMenuItem(child: Text(value), value: key,));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // print('build list ${this.itemsList.length}');
    return Container(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: DropdownButton(
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

