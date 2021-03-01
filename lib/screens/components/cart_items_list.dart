import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/cart_item.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/screens/components/cart_item_container.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';

class ItemsList extends StatefulWidget {
  final VoidCallback onDelete;

  const ItemsList({Key key, this.onDelete}) : super(key: key);
  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
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
        TopNotch(
          "Carrinho",
          margin: EdgeInsets.only(bottom: 15),
        ),
        _cartItemContainers.isEmpty
            ? Expanded(
                child: Center(
                  child: Text(
                    "Nada por aqui...",
                    textAlign: TextAlign.center,
                    style: AppStyle.greyRegularText16Style(),
                  ),
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _cartItemContainers,
                  ),
                ),
              ),
        SizedBox(height: 15.0),
      ],
    );
  }
}
