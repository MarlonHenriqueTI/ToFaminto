import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'money_change_text_field.dart';

class MoneyChangeWidget extends StatelessWidget {
  const MoneyChangeWidget({
    Key key,
    @required TextEditingController moneyChangeController,
  })  : _moneyChangeController = moneyChangeController,
        super(key: key);

  final TextEditingController _moneyChangeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26.0)),
        border: Border.all(color: Colors.grey[200], width: 1.0),
      ),
      child: Column(
        children: [
          Text(
            "Precisa de troco?",
            style: AppStyle.mediumGreyMediumText18Style(),
          ),
          MoneyChangeTextField(moneyChangeController: _moneyChangeController),
        ],
      ),
    );
  }
}
