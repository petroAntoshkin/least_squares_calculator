import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyRadioButton extends StatefulWidget {
  bool isSelected;

  MyRadioButton({this.isSelected});

  @override
  _MyRadioButtonState createState() => _MyRadioButtonState();
}

class _MyRadioButtonState extends State<MyRadioButton>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    // controller =
    //     AnimationController(duration: const Duration(seconds: 1), vsync: this);
    // animation = Tween<double>(begin: 0, end: 0.7).animate(controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });
    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _isSelected = widget.isSelected == true;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black26,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.85,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isSelected ? Colors.black87 : Color(0x00ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
