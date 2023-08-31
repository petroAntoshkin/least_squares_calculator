import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';
import 'package:provider/provider.dart';

class CancelEditButton extends StatefulWidget {

  final void Function()? callback;
  const CancelEditButton({Key? key, required this.callback}) : super(key: key);

  @override
  State<CancelEditButton> createState() => _CancelEditButtonState();
}

class _CancelEditButtonState extends State<CancelEditButton> {
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return SizedBox(
      width: Presets.MINIMUM_TAP_SIZE,
      child: isKeyboardVisible ? GestureDetector(
        onTap: widget.callback,
        child: SizedBox(
          height: Presets.MINIMUM_TAP_SIZE,
          child: Container(
            decoration: BoxDecoration(
              color: Provider.of<DataProvider>(context).theme.primaryColor,
              borderRadius: BorderRadius.circular(Presets.ARC_SIZE),
            ),
            child: Icon(Icons.cancel_outlined),
          ),
        ),
      )
          : Container(),
    );
  }
}
