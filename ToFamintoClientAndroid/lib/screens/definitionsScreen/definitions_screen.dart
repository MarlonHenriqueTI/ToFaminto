import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';

enum RouteAddress { PROFILE, ADDRESSES, CARDS, WALLET }

class DefinitionsScreen extends StatelessWidget {
  void onPressed(BuildContext context, RouteAddress route) {
    if (route == RouteAddress.PROFILE) {
      Provider.of<RoutesState>(context, listen: false).changeToProfileScreen();
    } else if (route == RouteAddress.ADDRESSES) {
      Provider.of<RoutesState>(context, listen: false)
          .changeToAddressesScreen();
    } else if (route == RouteAddress.CARDS) {
      Provider.of<RoutesState>(context, listen: false).changeToCardsScreen();
    } else if (route == RouteAddress.WALLET) {
      Provider.of<RoutesState>(context, listen: false).changeToWalletScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TopNotch("Definições"),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              DefinitionsIndividualContainer(
                text: "Perfil",
                onPressed: () => onPressed(context, RouteAddress.PROFILE),
              ),
              DefinitionsIndividualContainer(
                text: "Endereços",
                onPressed: () => onPressed(context, RouteAddress.ADDRESSES),
              ),
              DefinitionsIndividualContainer(
                text: "Cartões",
                onPressed: () => onPressed(context, RouteAddress.CARDS),
              ),
              DefinitionsIndividualContainer(
                text: "Carteira Digital",
                onPressed: () => onPressed(context, RouteAddress.WALLET),
              ),
              logoutButton(context),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector logoutButton(context) {
    return GestureDetector(
      onTap: () {
        Provider.of<UserState>(context, listen: false).deleteUser();
        Provider.of<CartState>(context, listen: false).clearCart();
        Provider.of<CheckoutState>(context, listen: false).resetState();
        Provider.of<RoutesState>(context, listen: false).resetState();
        Provider.of<RoutesState>(context, listen: false)
            .changeToLoginRegisterScreen();
      },
      child: Container(
        height: 30,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(36.0)),
        ),
        child: Text(
          "DESLOGAR",
          style: AppStyle.whiteSemiBoldText16Style(),
        ),
      ),
    );
  }
}

class DefinitionsIndividualContainer extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DefinitionsIndividualContainer({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9.0)),
          border: Border.all(color: AppStyle.lightGrey, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: AppStyle.mediumGreyRegularTex16tStyle(),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppStyle.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
