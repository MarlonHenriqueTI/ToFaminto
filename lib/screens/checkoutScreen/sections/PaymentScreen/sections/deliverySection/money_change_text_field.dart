import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class MoneyChangeTextField extends StatelessWidget {
  const MoneyChangeTextField({
    Key key,
    @required TextEditingController moneyChangeController,
  })  : _moneyChangeController = moneyChangeController,
        super(key: key);

  final TextEditingController _moneyChangeController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "R\$",
          style: AppStyle.mediumGreyMediumText16Style(),
        ),
        Container(
          width: 100,
          child: TextField(
            style: AppStyle.mediumGreyMediumText18Style(),
            cursorColor: AppStyle.yellow,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: _moneyChangeController,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
