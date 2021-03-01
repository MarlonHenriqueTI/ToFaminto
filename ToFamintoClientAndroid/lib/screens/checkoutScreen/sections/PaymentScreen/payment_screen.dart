import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/card.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/checkoutScreen/sections/PaymentScreen/components/cards_list.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';

import '../../../components/CardContainer.dart';
import 'components/add_new_card_button.dart';
import 'components/PaymentMethodSwitch.dart';
import 'sections/deliverySection/delivery_section.dart';

class PaymentScreen extends StatefulWidget {
  final CartState cartState;

  const PaymentScreen({@required this.cartState});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _hasLoaded = false;
  List<CardContainer> _cards;
  final _moneyChangeController = TextEditingController();
  String _error;
  bool _restaurantAcceptsOnlinePayment = false;

  void onContinuePressed(context) {
    final moneyChange = _moneyChangeController.text.length < 1
        ? 0
        : int.parse(_moneyChangeController.text);
    Provider.of<CheckoutState>(context, listen: false).moneyChange =
        moneyChange;
    Provider.of<CheckoutState>(context, listen: false).changeToResumeScreen();
  }

  void getSavedCards(BuildContext context) async {
    final result =
        await Provider.of<UserState>(context, listen: false).getSavedCards();
    if (result is ApiError) {
      setState(() {
        _error = result.text;
      });
    } else {
      if (result != null) {
        _cards = [];
        for (BankCard _bankCard in result) {
          _cards.add(CardContainer(card: _bankCard));
        }
      }
      setState(() {
        _hasLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _moneyChangeController.dispose();
    super.dispose();
  }

  Widget getSection(CheckoutState checkout) {
    if (_restaurantAcceptsOnlinePayment) {
      if (checkout.isPaymentOnline) {
        if (_error == null) {
          if (_hasLoaded) {
            return Expanded(child: CardsList(cards: _cards));
          } else {
            return CircularProgressIndicator();
          }
        } else {
          return Expanded(
            child: Center(
              child: Text(_error),
            ),
          );
        }
      }
    }

    return DeliverySection(moneyChangeController: _moneyChangeController);
  }

  @override
  void initState() {
    final minimalRestaurantData =
        Provider.of<RoutesState>(context, listen: false)
            .currentSelectedRestaurantMinData;

    _restaurantAcceptsOnlinePayment =
        minimalRestaurantData?.acceptsOnlinePayment ?? false;

    if (_restaurantAcceptsOnlinePayment &&
        Provider.of<CheckoutState>(context, listen: false).currentScreenIndex ==
            0) {
      getSavedCards(context);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final minimalRestaurantData =
        Provider.of<RoutesState>(context, listen: false)
            .currentSelectedRestaurantMinData;

    _restaurantAcceptsOnlinePayment =
        minimalRestaurantData?.acceptsOnlinePayment ?? false;

    if (_restaurantAcceptsOnlinePayment &&
        Provider.of<CheckoutState>(context, listen: false).currentScreenIndex ==
            0) {
      getSavedCards(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<CheckoutState>(
              builder: (_, checkout, __) => Container(
                child: getSection(checkout),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 15.0),
                Consumer<CheckoutState>(
                  builder: (___, checkout, ____) {
                    if (checkout.isPaymentOnline &&
                        _restaurantAcceptsOnlinePayment) {
                      return AddNewCardButton();
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                PaymentMethodSwitch(
                  isCurrentScreenOnline: _restaurantAcceptsOnlinePayment
                      ? Provider.of<CheckoutState>(context, listen: false)
                              .isPaymentOnline ??
                          true
                      : false,
                  acceptsOnlinePayment: _restaurantAcceptsOnlinePayment,
                ),
                if (Provider.of<CheckoutState>(context, listen: false)
                        .availableWalletBalance !=
                    0)
                  ChangeNotifierProvider.value(
                    value: widget.cartState,
                    child: DigitalWalletSelectionWidget(),
                  ),
                BottomScreenLargeButton(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  onPressed: (ctx) => onContinuePressed(ctx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      Text(
                        "CONTINUAR",
                        style: AppStyle.whiteSemiBoldText14Style(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DigitalWalletSelectionWidget extends StatefulWidget {
  const DigitalWalletSelectionWidget({
    Key key,
  }) : super(key: key);

  @override
  _DigitalWalletSelectionWidgetState createState() =>
      _DigitalWalletSelectionWidgetState();
}

class _DigitalWalletSelectionWidgetState
    extends State<DigitalWalletSelectionWidget> {
  bool _isSelected = false;

  void onTap(BuildContext context) {
    setState(() {
      _isSelected = !_isSelected;
    });
    Provider.of<CheckoutState>(context, listen: false).useWalletBalance =
        _isSelected;
    if (_isSelected) {
      Provider.of<CartState>(context, listen: false).addWalletBalanceDiscount(
          Provider.of<CheckoutState>(context, listen: false)
              .availableWalletBalance);
    } else {
      Provider.of<CartState>(context, listen: false)
          .removeWalletBalanceDiscount();
    }
  }

  @override
  void initState() {
    _isSelected =
        Provider.of<CheckoutState>(context, listen: false).useWalletBalance ??
            false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        border: Border.all(color: AppStyle.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "CARTEIRA DIGITAL: R\$ ${Provider.of<CheckoutState>(context, listen: false).availableWalletBalance.toStringAsFixed(2)}",
            style: AppStyle.greyMediumText14Style(),
          ),
          InkWell(
            onTap: () => onTap(context),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: _isSelected
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.topRight,
                        colors: [
                          AppStyle.yellowGradientStart,
                          AppStyle.yellowGradientEnd,
                        ],
                      )
                    : null,
                borderRadius: _isSelected
                    ? const BorderRadius.all(Radius.circular(24.0))
                    : null,
              ),
              child: Text(
                "UTILIZAR",
                style: _isSelected
                    ? AppStyle.whiteMediumTextStyle()
                    : AppStyle.greyMediumText14Style(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
