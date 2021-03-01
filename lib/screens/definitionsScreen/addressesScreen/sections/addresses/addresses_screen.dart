import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';

import 'Components/address_card.dart';

class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<AddressCard> _addressCards = [];
  bool _isLoaded = false;
  String _error;

  void changeToNewAddressScreen(context) {
    Provider.of<RoutesState>(context, listen: false).changeToNewAddressScreen();
  }

  void setDefaultAddress(BuildContext context, int clientAddressId) async {
    await Provider.of<UserState>(context, listen: false)
        .setDefaultAddress(clientAddressId);
    Provider.of<CartState>(context, listen: false).clearCart();
    Provider.of<CheckoutState>(context, listen: false).resetState();
    Provider.of<UserState>(context, listen: false).fetchWallet();
    return setState(() {
      buildAddresses(context, canFetch: false);
    });
  }

  void remove(int id) {
    setState(() {
      _addressCards.removeWhere((element) => element.clientAddress.id == id);
    });
  }

  void buildAddresses(context, {canFetch = true}) async {
    final response = await Provider.of<UserState>(context, listen: false)
        .getSavedAddresses(fetchNewData: canFetch);

    if (response == null) {
      Provider.of<RoutesState>(context, listen: false)
          .changeToNewAddressScreen();
      return;
    }
    final defaultAddressId =
        await Provider.of<UserState>(context, listen: false)
            .getDefaultAddressId();

    if (response is ApiError) {
      setState(() {
        _error = response.text;
      });
    } else {
      _addressCards = [];
      setState(() {
        for (final address in response) {
          _addressCards.add(AddressCard(
              remove: (id) => remove(id),
              defaultAddressId: defaultAddressId,
              clientAddress: address,
              onTap: (context, clientAddressId) =>
                  setDefaultAddress(context, clientAddressId)));
        }
        _isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    buildAddresses(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TopNotch(
              "Endereços",
              margin: const EdgeInsets.only(bottom: 10),
            ),
            _error == null
                ? _isLoaded
                    ? Expanded(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ..._addressCards ?? [],
                                  SizedBox(
                                    height: 70,
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              width: MediaQuery.of(context).size.width,
                              child: BottomScreenLargeButton(
                                child: Icon(
                                  Icons.add_outlined,
                                  color: AppStyle.yellow,
                                ),
                                onPressed: (ctx) =>
                                    changeToNewAddressScreen(ctx),
                                color: Colors.white,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                : Expanded(
                    child: Center(
                      child: Text(_error),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
