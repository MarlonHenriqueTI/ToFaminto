import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class TopNotch extends StatelessWidget {
  final String text;
  final bool applyMargin;
  final bool disableRoundedCorners;
  final EdgeInsetsGeometry margin;

  const TopNotch(
    this.text, {
    this.applyMargin = true,
    this.disableRoundedCorners = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: margin ?? (applyMargin ? EdgeInsets.only(bottom: 25) : null),
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
      decoration: BoxDecoration(
        borderRadius: disableRoundedCorners
            ? null
            : BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
        border: Border.all(
          color: Colors.grey[200],
          width: 1.0,
        ),
      ),
      child: Text(
        text,
        style: AppStyle.mediumGreyMediumText18Style(),
      ),
    );
  }
}
