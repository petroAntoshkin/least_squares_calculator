import 'package:flutter/widgets.dart';

class SubscribedIconButton extends StatelessWidget {
  final text;
  final iconData;
  final iconColor;

  const SubscribedIconButton(
      {Key? key, this.text, this.iconData, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(text),
        ),
      ],
    );
  }
}
