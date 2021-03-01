import 'package:flutter/material.dart';

import 'circular_button_component.dart';

class CircularButtonWithBottomText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const CircularButtonWithBottomText(
      {Key key, this.icon, this.text, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularButton(
          icon: icon,
          size: 38.0,
          iconColor: iconColor,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
