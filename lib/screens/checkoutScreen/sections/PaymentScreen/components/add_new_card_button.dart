import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/constants/enums.dart';
import 'package:to_faminto_client/providers/routes_state.dart';

class AddNewCardButton extends StatefulWidget {
  @override
  _AddNewCardButtonState createState() => _AddNewCardButtonState();
}

class _AddNewCardButtonState extends State<AddNewCardButton> {
  void changeToNewCardScreen(BuildContext context) {
    Provider.of<RoutesState>(context, listen: false)
        .changeToNewCheckoutCardScreen(returnTo: NavigationRoute.CHECKOUT);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppStyle.lightGrey),
        borderRadius: const BorderRadius.all(Radius.circular(36.0)),
      ),
      child: InkWell(
        onTap: () => changeToNewCardScreen(context),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //border: Border.all(color: Colors.grey[200], width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          ),
          child: const Icon(
            Icons.add_outlined,
            color: AppStyle.yellow,
          ),
        ),
      ),
    );
  }
}
