import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final Color iconColor;

  const CircularButton(
      {Key key,
      this.icon,
      this.size = 27.0,
      this.color = Colors.white,
      this.iconColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      elevation: 3.0,
      fillColor: color,
      constraints: const BoxConstraints(minWidth: 10.0, minHeight: 10.0),
      child: Icon(
        icon,
        color: iconColor,
        size: size,
      ),
      padding: const EdgeInsets.all(10.0),
      shape: const CircleBorder(),
    );
  }
}
