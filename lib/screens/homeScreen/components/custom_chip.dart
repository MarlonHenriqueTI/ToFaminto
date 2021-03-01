import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class CustomChip extends StatefulWidget {
  final String text;
  final Function onPressed;
  final bool isSelected;

  const CustomChip({
    @required this.text,
    @required this.onPressed,
    @required this.isSelected,
  });
  @override
  _CustomChipState createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  bool _isSelected;

  void _onTap() {
    setState(() {
      _isSelected = !_isSelected;
    });
    widget.onPressed(_isSelected);
  }

  @override
  void initState() {
    _isSelected = widget.isSelected ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(25.0, 6.0, 25.0, 6.0),
        margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(26.0),
          ),
          color: _isSelected ? Colors.white : Colors.transparent,
          border: Border.all(
            color: _isSelected ? Colors.white : AppStyle.lightGrey,
            width: 1.0,
          ),
        ),
        child: Text(
          widget.text,
          style: _isSelected
              ? AppStyle.pillYellowRegularTextStyle()
              : AppStyle.pillWhiteRegularTextStyle(),
        ),
      ),
    );
  }
}
