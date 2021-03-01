import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/cart_item.dart';
import 'package:to_faminto_client/providers/cart_state.dart';

class CartItemContainer extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback onDelete;

  const CartItemContainer({
    @required this.cartItem,
    @required this.onDelete,
  }) : assert(onDelete != null);

  @override
  _CartItemContainerState createState() => _CartItemContainerState();
}

class _CartItemContainerState extends State<CartItemContainer> {
  bool _isPressed = false;

  void onTap() {
    setState(() {
      _isPressed = !_isPressed;
    });
  }

  Text itemPayInfo() {
    final double total = widget.cartItem.totalPrice * widget.cartItem.quantity;
    return Text(
      "R\$ ${total.toStringAsFixed(2)}",
      style: AppStyle.greyMediumText16Style(),
      textAlign: TextAlign.right,
    );
  }

  IconButton itemInfo() {
    return IconButton(
      onPressed: () {
        Provider.of<CartState>(context, listen: false)
            .decreaseItemAmount(widget.cartItem.uniqueCartId);
        widget.onDelete();
      },
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9.0)),
          border: Border.all(
            color: AppStyle.lightGrey,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.cartItem.item.image,
                            scale: 100),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: Text(
                      widget.cartItem.item.name,
                      style: AppStyle.mediumGreyMediumText16Style(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (widget.cartItem.quantity > 1)
                    Text(
                      " x ",
                      style: AppStyle.mediumGreyMediumText16Style(),
                    ),
                  if (widget.cartItem.quantity > 1)
                    Text(
                      widget.cartItem.quantity.toString(),
                      style: AppStyle.mediumGreyMediumText16Style(),
                    ),
                ],
              ),
            ),
            if (_isPressed) itemInfo(),
            if (!_isPressed) itemPayInfo(),
          ],
        ),
      ),
    );
  }
}
