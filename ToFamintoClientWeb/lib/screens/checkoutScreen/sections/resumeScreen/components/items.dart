import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/models/cart_item.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/screens/components/cart_item_container.dart';

class Items extends StatefulWidget {
  final VoidCallback onDelete;

  const Items({Key key, this.onDelete}) : super(key: key);
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<CartItemContainer> _cartItemContainers = [];

  void onDelete() {
    _cartItemContainers = [];
    List<CartItem> _cartItems =
        Provider.of<CartState>(context, listen: false).cartItems;

    for (CartItem item in _cartItems) {
      _cartItemContainers
          .add(CartItemContainer(cartItem: item, onDelete: onDelete));
    }
    widget.onDelete();
  }

  @override
  void initState() {
    super.initState();
    List<CartItem> _cartItems =
        Provider.of<CartState>(context, listen: false).cartItems;

    for (CartItem item in _cartItems) {
      _cartItemContainers
          .add(CartItemContainer(cartItem: item, onDelete: onDelete));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: _cartItemContainers,
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
