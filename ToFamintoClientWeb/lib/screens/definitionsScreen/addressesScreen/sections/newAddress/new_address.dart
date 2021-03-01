import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';

import 'Components/address_form.dart';
import 'Components/seach_container.dart';

class NewAddress extends StatefulWidget {
  final RoutesState routesState;
  final UserState userState;
  final bool comesFromCheckout;

  NewAddress(
      {@required this.routesState,
      @required this.userState,
      this.comesFromCheckout = false});

  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final _stateController = TextEditingController();

  final _cityController = TextEditingController();

  final _neighborhoodController = TextEditingController();

  final _streetController = TextEditingController();

  final _doorNumberController = TextEditingController();

  final _referenceController = TextEditingController();

  final _typeController = TextEditingController();

  final matchStreetNameWithoutNumber =
      RegExp(r"(^\D+?) -", caseSensitive: false);

  final matchStreetNameWithNumber = RegExp(r"(^\D+?),", caseSensitive: false);

  final matchDoorNumber = RegExp(r"(\d+) -", caseSensitive: false);

  final matchNeighborhoodWithNumber =
      RegExp(r"- (\D+?), ", caseSensitive: false);

  final matchNeighborhoodWithoutNumber =
      RegExp(r"- (\D+?), \w+ ", caseSensitive: false);

  final matchCity = RegExp(r", (\D+?) - ", caseSensitive: false);

  final matchState = RegExp(r" (\w{2}),", caseSensitive: false);

  bool _hasAutoCompleted = false;
  bool _isFetchingData = false;
  bool _isManual = false;

  void autoFillAddress(List terms) {
    int index = 0;
    final street = terms[index]['value'];
    index++;
    String doorNumber = "";
    int value = int.tryParse(terms[index]['value']);
    if (value != null) {
      doorNumber = value.toString();
      index++;
    }
    final neighborhood = terms[index]['value'];
    index++;
    final city = terms[index]['value'];
    final state = terms[terms.length - 2]['value'];

    _streetController.text = street;
    _doorNumberController.text = doorNumber;
    _neighborhoodController.text = neighborhood;
    _cityController.text = city;
    _stateController.text = state;

    setState(() {
      _hasAutoCompleted = true;
    });
  }

  void saveAddress(BuildContext context) async {
    setState(() {
      _isFetchingData = true;
    });
    final user = await Provider.of<UserState>(context, listen: false).getUser();

    if (_typeController.text.length > 15)
      _typeController.text = _typeController.text.substring(0, 10);

    Provider.of<UserState>(context, listen: false)
        .saveNewAddress(
      UserAddress(
        userId: user.id,
        doorNumber: int.parse(_doorNumberController.text),
        streetName: _streetController.text,
        stateName: _stateController.text,
        neighborhoodName: _neighborhoodController.text,
        cityName: _cityController.text,
        type: _typeController.text,
        complement: _referenceController.text,
      ),
    )
        .whenComplete(() {
      setState(() {
        _isFetchingData = false;
      });

      if (user.isGuess) {
        Provider.of<RoutesState>(context, listen: false)
            .changeToHomeScreen(shouldResetState: false);
      } else {
        Provider.of<CartState>(context, listen: false).clearCart();
        Provider.of<CheckoutState>(context, listen: false).resetState();
        Provider.of<UserState>(context, listen: false).fetchWallet();
        Provider.of<RoutesState>(context, listen: false)
            .changeToAddressesScreen();
      }
    });
  }

  void manualFill() {
    setState(() {
      _isManual = true;
    });
  }

  @override
  void dispose() {
    _stateController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _streetController.dispose();
    _doorNumberController.dispose();
    _referenceController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_isFetchingData)
              LinearProgressIndicator(
                backgroundColor: Colors.red,
              ),
            TopNotch(
              "Novo Endereço",
              applyMargin: false,
            ),
            Container(
              child: Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _hasAutoCompleted || _isManual
                          ? AddressFrom(
                              stateController: _stateController,
                              cityController: _cityController,
                              doorNumberController: _doorNumberController,
                              neighborhoodController: _neighborhoodController,
                              referenceController: _referenceController,
                              streetController: _streetController,
                              typeController: _typeController,
                              isManual: _isManual,
                            )
                          : SearchContainer(
                              autoFillAddress: autoFillAddress,
                              manualFill: manualFill,
                            ),
                      if (_hasAutoCompleted || _isManual)
                        MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(
                              value: widget.userState,
                            ),
                            ChangeNotifierProvider.value(
                              value: widget.routesState,
                            ),
                          ],
                          child: BottomScreenLargeButton(
                            onPressed: (ctx) {
                              saveAddress(ctx);
                            },
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Text(
                              "ADICIONAR",
                              style: AppStyle.whiteSemiBoldText16Style(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
