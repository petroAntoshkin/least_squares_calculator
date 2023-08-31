import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';
import 'package:provider/provider.dart';

class ValueTextField extends StatelessWidget {
  final Function callback;
  final Function(String) onChangeCallback;
  final flag;
  ValueTextField({Key? key, @required this.flag, required this.callback, required this.onChangeCallback}) : super(key: key);
/*
  @override
  State<ValueTextField> createState() => _ValueTextFieldState();
}

class _ValueTextFieldState extends State<ValueTextField> {*/

  final TextEditingController _textController = TextEditingController();

  final FocusNode focusNode = FocusNode();

/*  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    // final editIndex = Provider.of<DataProvider>(context).editIndex;
    _textController.text = flag == 'x' ? Provider.of<DataProvider>(context).currentXValue : Provider.of<DataProvider>(context).currentYValue;

    String prefix = flag == 'x' ? ' X ' : ' Y ';
    onChangeCallback(_textController.text);
    var tf =  TextField(
      onChanged: (String value) {
        onChangeCallback(value);
      },
      // scrollPadding: EdgeInsets.all(0.0),
      onTap: () => Provider.of<DataProvider>(context, listen: false).focusOnText = flag,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(Presets.numberRegExp)
      ],
      onEditingComplete: callback(),
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      controller: _textController,
      decoration: InputDecoration(
        hintText: prefix,
        fillColor: Provider.of<DataProvider>(context, listen: false).theme.primaryColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: Presets.defaultBorderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: Presets.defaultBorderRadius,
        ),
      ),
    );
    // debugPrint('focus on:${Provider.of<DataProvider>(context, listen: false).focusOnText}');
    if (Provider.of<DataProvider>(context, listen: false).focusOnText == flag) {
      focusNode.requestFocus();
    }
    return tf;
  }
}
