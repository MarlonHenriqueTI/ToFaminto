import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/user.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/restaurants_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';

import '../components/cart_items_list.dart';
import '../components/PriceResumeContainer.dart';

class CartScreen extends StatefulWidget {
  final RoutesState routesState;
  final RestaurantsState restaurantsState;
  final CheckoutState checkoutState;

  const CartScreen({
    @required this.routesState,
    @required this.restaurantsState,
    @required this.checkoutState,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void onDelete() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: ItemsList(
          onDelete: onDelete,
        )),
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: widget.routesState,
            ),
            ChangeNotifierProvider.value(
              value: widget.restaurantsState,
            ),
            ChangeNotifierProvider.value(
              value: widget.checkoutState,
            ),
          ],
          child: NavigationAndActions(),
        ),
      ],
    );
  }
}

class NavigationAndActions extends StatefulWidget {
  @override
  _NavigationAndActionsState createState() => _NavigationAndActionsState();
}

class _NavigationAndActionsState extends State<NavigationAndActions> {
  Future<bool> askToLoginRegister(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          "Para continuar faça login ou cadastre-se",
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

  void changeToCheckoutScreen(
      BuildContext context, BuildContext scaffoldContext) async {
    User user = await Provider.of<UserState>(context, listen: false).getUser();
    UserAddress address = await Provider.of<UserState>(context, listen: false)
        .getDefaultAddress();

    if (user.isGuess) {
      final bool response = await askToLoginRegister(context);
      if (response) {
        Provider.of<RoutesState>(context, listen: false)
            .changeToLoginRegisterScreen();
        return;
      } else {
        return;
      }
    }

    if (address.cityName == "Erro") {
      showCheckoutError(context, message: "Endereço inválido");
      return;
    }

    double totalCartValue =
        Provider.of<CartState>(context, listen: false).bruteTotalCartValue;
    double restaurantMinOrderPrice =
        Provider.of<RoutesState>(context, listen: false)
            .currentSelectedRestaurantMinData
            .deliveryData
            .minimalOrderPrice;

    if (totalCartValue < restaurantMinOrderPrice) {
      showCheckoutError(scaffoldContext,
          minOrderPrice: restaurantMinOrderPrice);
      return;
    }
    Provider.of<CheckoutState>(context, listen: false).availableWalletBalance =
        user.wallet.balance;
    Provider.of<CheckoutState>(context, listen: false).cartItems =
        Provider.of<CartState>(context, listen: false).cartItems;
    Provider.of<RoutesState>(context, listen: false).changeToCheckoutScreen();
    Provider.of<RestaurantsState>(context, listen: false)
        .selectedRestaurantSlug = null;
  }

  void showCheckoutError(context, {double minOrderPrice, String message}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(16),
        content: Text(
          message == null
              ? "Seu pedido precisa ser no mínimo R\$ ${minOrderPrice.toStringAsFixed(2)}."
              : message,
          style: AppStyle.whiteMediumText16Style(),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void checkDeliveryType(context) {
    if (Provider.of<CheckoutState>(context, listen: false).deliveryType == 2) {
      Provider.of<CartState>(context, listen: false).setDeliveryTax(0);
    } else {
      Provider.of<CartState>(context, listen: false).setDeliveryTax(
          double.parse(Provider.of<RoutesState>(context, listen: false)
              .currentSelectedRestaurantMinData
              .deliveryCharge));
    }
  }

  @override
  void initState() {
    checkDeliveryType(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<CartState>(context).itemCount > 0
        ? Column(
            children: [
              const PriceResumeContainer(),
              const SizedBox(height: 15.0),
              BottomScreenLargeButton(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                onPressed: (ctx) => changeToCheckoutScreen(ctx, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      "CHECKOUT",
                      style: AppStyle.whiteSemiBoldText14Style(),
                    ),
                  ],
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
