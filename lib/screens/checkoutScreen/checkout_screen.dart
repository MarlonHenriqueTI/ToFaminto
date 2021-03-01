import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'sections/PaymentScreen/payment_screen.dart';
import 'sections/resumeScreen/resume_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final CheckoutState checkoutState;
  final CartState cartState;
  final RoutesState routesState;
  final UserState userState;
  const CheckoutScreen({
    @required this.checkoutState,
    @required this.cartState,
    @required this.routesState,
    @required this.userState,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: checkoutState,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: MainContent(
            checkoutState: checkoutState,
            cartState: cartState,
            routesState: routesState,
            userState: userState,
          ),
        ),
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  final CheckoutState checkoutState;
  final CartState cartState;
  final RoutesState routesState;
  final UserState userState;
  final int startIndex;

  const MainContent({
    @required this.checkoutState,
    @required this.cartState,
    @required this.routesState,
    this.startIndex,
    @required this.userState,
  });

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  Widget getCurrentScreen(int _currentScreen) {
    if (_currentScreen == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TopNotchWithNavigation(
            text: "Pagamento",
            currentIndex: _currentScreen,
          ),
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: widget.userState),
              ChangeNotifierProvider.value(value: widget.routesState),
            ],
            child: PaymentScreen(cartState: widget.cartState),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          TopNotchWithNavigation(
            text: "Resumo",
            currentIndex: _currentScreen,
          ),
          Expanded(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: widget.cartState),
                ChangeNotifierProvider.value(value: widget.routesState),
                ChangeNotifierProvider.value(value: widget.checkoutState),
                ChangeNotifierProvider.value(value: widget.userState),
              ],
              child: ResumeScreen(),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutState>(
        builder: (context, checkout, _) =>
            getCurrentScreen(checkout.currentScreenIndex));
  }
}

class TopNotchWithNavigation extends StatelessWidget {
  final String text;
  final int currentIndex;

  const TopNotchWithNavigation({this.text, this.currentIndex});

  void onNavigationPressed(BuildContext context, int index) {
    Provider.of<CheckoutState>(context, listen: false)
        .changeToScreenByIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(20, 20.0, 20, 10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: const Radius.circular(40.0),
          bottomRight: const Radius.circular(40.0),
        ),
        border: Border.all(
          color: AppStyle.lightGrey,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: AppStyle.mediumGreyMediumText18Style(),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navigationIcon(Icons.credit_card, 0, currentIndex, context,
                  onNavigationPressed),
              navigationIcon(
                  Icons.list, 1, currentIndex, context, onNavigationPressed),
            ],
          )
        ],
      ),
    );
  }

  InkWell navigationIcon(IconData iconData, int myIndex, int currentIndex,
      context, Function onTap) {
    return InkWell(
      onTap: () => onTap(context, myIndex),
      child: Container(
        width: 69,
        height: 37,
        decoration: BoxDecoration(
          color: myIndex == currentIndex ? AppStyle.yellow : null,
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        ),
        child: Icon(
          iconData,
          color: myIndex == currentIndex ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }
}
