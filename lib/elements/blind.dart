import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class Blind extends StatelessWidget {
  const Blind({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return isKeyboardVisible ? Container(color: Colors.black.withAlpha(150)) : Container();
  }
}
