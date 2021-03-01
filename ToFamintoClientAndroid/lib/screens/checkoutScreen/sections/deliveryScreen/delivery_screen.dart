import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';

import 'components/addresses.dart';

class AddressScreen extends StatefulWidget {
  final UserState userState;

  const AddressScreen({@required this.userState});
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _hasAddressAssigned = false;
  void changeToNextScreen(context) {
    if (_hasAddressAssigned) {
      Provider.of<CheckoutState>(context, listen: false).changeToCardScreen();
    }
  }

  void changeToAddressScreen(BuildContext context) {
    Provider.of<RoutesState>(context, listen: false).changeToNewAddressScreen();
  }

  void onAddressAssigned() {
    _hasAddressAssigned = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider.value(
              value: widget.userState,
              child: SingleChildScrollView(
                child: Addresses(
                  onAddressAssigned: onAddressAssigned,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          BottomScreenLargeButton(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.add_outlined,
              color: Colors.grey[400],
            ),
            onPressed: (ctx) => changeToAddressScreen(ctx),
            color: Colors.white,
            width: double.infinity,
          ),
          BottomScreenLargeButton(
            margin: EdgeInsets.symmetric(horizontal: 20),
            onPressed: (ctx) => changeToNextScreen(ctx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                Text(
                  "CONTINUAR",
                  style: AppStyle.whiteSemiBoldText14Style(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
