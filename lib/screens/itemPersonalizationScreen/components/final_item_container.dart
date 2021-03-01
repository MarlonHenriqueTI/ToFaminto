import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/cart_item.dart';
import 'package:to_faminto_client/providers/cart_state.dart';

class FinalItemContainer extends StatefulWidget {
  final int uniqueItemCartId;
  final double topMargin;
  const FinalItemContainer({
    this.uniqueItemCartId,
    this.topMargin,
  });

  @override
  _FinalItemContainerState createState() => _FinalItemContainerState();
}

class _FinalItemContainerState extends State<FinalItemContainer> {
  int _amount;
  CartItem _cartItem;
  List<AddonColumn> _addons = [];

  void increaseAmount(context) {
    setState(() {
      _amount = Provider.of<CartState>(context, listen: false)
          .increaseItemAmount(widget.uniqueItemCartId);
      _cartItem = Provider.of<CartState>(context, listen: false)
          .getCartItemByUniqueId(widget.uniqueItemCartId);
      if (_cartItem != null) {
        _amount = _cartItem.quantity;
        _addons = [];
        for (var cartAddon in _cartItem.cartAddons) {
          _addons.add(
            AddonColumn(
              addonName: cartAddon.addon.name,
              addonQuantity: cartAddon.quantity,
              addonPrice: (cartAddon.price * cartAddon.quantity) * _amount,
            ),
          );
        }
      }
    });
  }

  void decreaseAmount(context) {
    if (_amount > 1) {
      setState(() {
        _amount = Provider.of<CartState>(context, listen: false)
            .decreaseItemAmount(widget.uniqueItemCartId);
        _cartItem = Provider.of<CartState>(context, listen: false)
            .getCartItemByUniqueId(widget.uniqueItemCartId);
        if (_cartItem != null) {
          _amount = _cartItem.quantity;
          _addons = [];
          for (var cartAddon in _cartItem.cartAddons) {
            _addons.add(
              AddonColumn(
                addonName: cartAddon.addon.name,
                addonQuantity: cartAddon.quantity,
                addonPrice: (cartAddon.price * cartAddon.quantity) * _amount,
              ),
            );
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cartItem = Provider.of<CartState>(context, listen: false)
        .getCartItemByUniqueId(widget.uniqueItemCartId);
    if (_cartItem != null) {
      _amount = _cartItem.quantity;
      for (var cartAddon in _cartItem.cartAddons) {
        _addons.add(
          AddonColumn(
            addonName: cartAddon.addon.name,
            addonQuantity: cartAddon.quantity,
            addonPrice: (cartAddon.price * cartAddon.quantity) * _amount,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, widget.topMargin ?? 0, 10, 7),
      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9.0)),
        border: Border.all(
          color: Colors.grey[200],
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          _cartItem.item.name,
                          style: AppStyle.mediumGreyMediumText16Style(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'R\$ ${(_cartItem.totalPrice * _cartItem.quantity).toStringAsFixed(2)}',
                        style: AppStyle.greyMediumText16Style(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 34,
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => decreaseAmount(context),
                      iconSize: 15,
                      icon: Icon(Icons.remove_outlined),
                    ),
                    Text(
                      _amount.toString(),
                      style: AppStyle.greyMediumText16Style(),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => increaseAmount(context),
                      iconSize: 15,
                      icon: Icon(Icons.add_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _addons,
            ),
          ),
        ],
      ),
    );
  }
}

class AddonColumn extends StatelessWidget {
  final addonName;
  final addonPrice;
  final addonQuantity;
  const AddonColumn({
    this.addonName,
    this.addonQuantity,
    this.addonPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          addonQuantity > 1 ? "${addonQuantity}x $addonName" : addonName,
          style: AppStyle.mediumGreyMediumTex14tStyle(),
        ),
        Text(
          "+R\$ ${addonPrice.toString()}",
          style: AppStyle.greyMediumText14Style(),
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
