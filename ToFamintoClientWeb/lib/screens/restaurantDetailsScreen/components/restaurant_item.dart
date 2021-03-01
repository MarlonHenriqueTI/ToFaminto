import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/item.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/utilities/size_config.dart';

class RestaurantItem extends StatelessWidget {
  final Item item;
  final double storeTax;
  final bool restaurantIsClosed;
  final Function showSnackBar;

  const RestaurantItem({
    this.item,
    this.storeTax,
    this.restaurantIsClosed = false,
    @required this.showSnackBar,
  });

  Future<bool> askIfWantsToLooseCartItems(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          "Ao adicionar um item de outra loja você perderá seus itens atuais.",
          style: AppStyle.mediumGreyMediumText16Style(),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Voltar",
              style: AppStyle.mediumGreyMediumTex14tStyle(),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Confirmar",
              style: AppStyle.mediumGreyMediumTex14tStyle(),
            ),
          ),
        ],
        elevation: 1.0,
      ),
    );
  }

  void showRestaurantIsClosedSnackbar() {
    showSnackBar();
  }

  void changeToItemsScreen(BuildContext context, int uniqueCartId) {
    Provider.of<RoutesState>(context, listen: false)
        .changeToItemScreen(item, uniqueCartId);
  }

  /// returns -1 if the item being added belongs to a different store from
  /// the items currently on the cart
  int addNewItem(BuildContext context) {
    return Provider.of<CartState>(context, listen: false)
        .addNewItem(item, storeTax);
  }

  void deleteAllCartItems(BuildContext context) {
    Provider.of<CartState>(context, listen: false).clearCart();
  }

  void addToCart(BuildContext context) async {
    if (restaurantIsClosed) {
      showRestaurantIsClosedSnackbar();
      return;
    }
    final uniqueCartId = addNewItem(context);
    if (uniqueCartId == -1) {
      final canProceed = await askIfWantsToLooseCartItems(context);
      if (canProceed) {
        deleteAllCartItems(context);
        changeToItemsScreen(context, addNewItem(context));
      }
    } else {
      changeToItemsScreen(context, uniqueCartId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => addToCart(context),
      child: Container(
        margin: EdgeInsets.only(top: SizeConstants.itemTopSeparator),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (item.image != null)
              Container(
                width: SizeConstants.itemImageSize,
                height: SizeConstants.itemImageSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.image, scale: 100),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            if (item.image != null)
              SizedBox(width: SizeConstants.horizontalSmallSeparator),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.name ?? "",
                            style: AppStyle.mediumGreyMediumText16Style(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        if (double.tryParse(item.price) != 0.0)
                          Text(
                            'R\$ ${item.price ?? ""}',
                            style: AppStyle.greyMediumText14Style(),
                          ),
                      ],
                    ),
                    SizedBox(
                        height: SizeConstants.ITEM_TITLE_CONTENT_SEPARATOR),
                    Text(
                      item.description ?? "",
                      style: AppStyle.greyRegularText14Height1dot5Style(),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
