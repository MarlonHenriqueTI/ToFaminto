import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';

import 'address_card.dart';

class Addresses extends StatefulWidget {
  final Function onAddressAssigned;

  const Addresses({@required this.onAddressAssigned});
  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  int _currentAddressId;

  void changeCurrentAddress(context, int id) {
    widget.onAddressAssigned();
    Provider.of<CheckoutState>(context, listen: false).selectedAddressId = id;
    Provider.of<UserState>(context, listen: false).setDefaultAddress(id);
    setState(() {
      _currentAddressId = id;
    });
  }

  List<AddressCard> buildAddressCards(List<UserAddress> addresses) {
    List<AddressCard> _addresses = [];

    for (UserAddress address in addresses) {
      _addresses.add(AddressCard(
        clientAddress: address,
        onTap: (context, index) => changeCurrentAddress(context, index),
        currentAddressId: _currentAddressId,
        isSelected: address.id == _currentAddressId,
      ));
    }

    return _addresses;
  }

  void initiateData() async {
    Provider.of<CheckoutState>(context, listen: false).fetchAddresses();
    _currentAddressId =
        Provider.of<CheckoutState>(context, listen: false).selectedAddressId;
    if (_currentAddressId == null) {
      _currentAddressId = await Provider.of<UserState>(context, listen: false)
          .getDefaultAddressId();
      if (_currentAddressId != null) {
        widget.onAddressAssigned();
      }
    } else {
      widget.onAddressAssigned();
    }
  }

  @override
  void initState() {
    initiateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutState>(
      builder: (context, checkout, child) {
        return Column(
          children: buildAddressCards(checkout.allAddresses),
        );
      },
    );
  }
}
