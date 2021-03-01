import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class BottomScreenLargeButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final Color color;
  final double width;
  final EdgeInsetsGeometry margin;
  final bool canExpand;

  const BottomScreenLargeButton({
    @required this.onPressed,
    @required this.child,
    this.color,
    this.width,
    @required this.margin,
    this.canExpand = false,
  }) : assert(margin != null);

  @override
  Widget build(BuildContext context) {
    return canExpand
        ? Expanded(
            child: button(context),
          )
        : Container(
            child: button(context),
          );
  }

  InkWell button(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(context),
      child: Container(
        height: 60,
        width: width ?? MediaQuery.of(context).size.width,
        margin: margin,
        padding: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: color == null
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppStyle.yellowGradientStart,
                    AppStyle.yellowGradientEnd,
                  ],
                )
              : null,
          color: color != null ? color : null,
          border: color != null
              ? Border.all(color: Colors.grey[200], width: 1.0)
              : null,
          borderRadius: BorderRadius.all(Radius.circular(36.0)),
        ),
        child: child,
      ),
    );
  }
}
