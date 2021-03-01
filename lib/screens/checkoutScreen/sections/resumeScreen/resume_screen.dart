import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/PriceResumeContainer.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';

import 'components/input_fields_container.dart';
import 'components/items.dart';
import 'components/resume_input_field.dart';

const successSnackBarAnimationDuration = Duration(seconds: 1);
const errorSnackBarAnimationDuration = Duration(seconds: 3);

class ResumeScreen extends StatefulWidget {
  @override
  _ResumeScreenState createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final _commentController = TextEditingController();
  final _couponController = TextEditingController();
  final _cvvController = TextEditingController();

  String _securityCode;
  bool _securityCodeIsValid = false;
  bool _isPaymentOnline;

  void onOrderButtonPressed(BuildContext context) async {
    if (Provider.of<CartState>(context, listen: false).subtotalCartValue() ==
        0) {
      showPaymentError(context,
          customMessage: "Subtotal do carrinho não pode ser R\$ 0!");
    }

    if (_isPaymentOnline && !_securityCodeIsValid) {
      validateCVV(context);
      return;
    }
    if (validateComment()) {
      if (_securityCodeIsValid) Navigator.of(context).pop();
      _securityCodeIsValid = false;
      final user =
          await Provider.of<UserState>(context, listen: false).getUser();
      Provider.of<CheckoutState>(context, listen: false).selectedRestaurantId =
          Provider.of<RoutesState>(context, listen: false)
              .currentSelectedRestaurantMinData
              .id;

      final address = await Provider.of<UserState>(context, listen: false)
          .getDefaultAddress();

      showPaymentInfo(context);
      final result =
          await Provider.of<CheckoutState>(context, listen: false).placeOrder(
        user: user,
        address: address,
        securityCode: _securityCode,
        comment: _commentController.text,
      );
      if (result == true) {
        if (_isPaymentOnline) Navigator.of(context).pop();
        showPaymentSuccess(context);
        await Future.delayed(successSnackBarAnimationDuration);
        Provider.of<CartState>(context, listen: false).clearCart();
        Provider.of<CheckoutState>(context, listen: false).resetState();
        Provider.of<UserState>(context, listen: false).fetchWallet();
        Provider.of<RoutesState>(context, listen: false)
            .changeToHomeScreen(shouldResetState: true);
      } else if (result is ApiError) {
        _cvvController.clear();
        showPaymentError(context,
            customMessage: "Ooops... Verifique sua conexão");
      } else {
        _cvvController.clear();
        showPaymentError(context, customMessage: "Ooops... Erro desconhecido");
      }
    }
  }

  void showPaymentInfo(context) {
    setState(() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(16),
          content: Text(
            "Aguarde...",
            style: AppStyle.whiteMediumText16Style(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  void showPaymentSuccess(context) {
    setState(() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(16),
          content: Text(
            "Pedido realizado com sucesso!",
            style: AppStyle.whiteMediumText16Style(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          duration: successSnackBarAnimationDuration,
        ),
      );
    });
  }

  void showPaymentError(context,
      {String customMessage = "Ocorreu um erro ao processar seu pedido..."}) {
    setState(() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(16),
          content: Text(
            customMessage,
            style: AppStyle.whiteMediumText16Style(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: errorSnackBarAnimationDuration,
        ),
      );
    });
  }

  void validate(BuildContext context) {
    _securityCodeIsValid = _cvvController.text.length > 2;
    if (_securityCodeIsValid) {
      _securityCode = _cvvController.text;
      onOrderButtonPressed(context);
    }
  }

  void validateCVV(BuildContext context) {
    Scaffold.of(context).showBottomSheet((_) {
      return Container(
        height: 90,
        width: double.infinity,
        color: Colors.amber,
        child: Column(
          children: [
            ResumeInputField(
              text: "CVV",
              keyboardType: TextInputType.number,
              isComment: false,
              controller: _cvvController,
              onPressed: () => validate(context),
              labelTextStyle: AppStyle.whiteRegularText16Style(),
              textStyle: AppStyle.whiteSemiBoldText20Style(),
              buttonColor: Colors.white,
              buttonIconColor: AppStyle.yellow,
              cursorColor: Colors.white,
            ),
          ],
        ),
      );
    });
  }

  bool validateComment() {
    return _commentController.text.length <= 100;
  }

  void onDelete(BuildContext context) {
    if (Provider.of<CartState>(context, listen: false).cartItems.isEmpty) {
      Provider.of<CartState>(context, listen: false).clearCart();
      Provider.of<CheckoutState>(context, listen: false).resetState();
      Provider.of<RoutesState>(context, listen: false)
          .changeToHomeScreen(shouldResetState: true);
    } else {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    _isPaymentOnline =
        Provider.of<CheckoutState>(context, listen: false).isPaymentOnline;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _usingWalletBalance =
          Provider.of<CheckoutState>(context, listen: false).useWalletBalance ??
              false;
      if (_usingWalletBalance) {
        Provider.of<CartState>(context, listen: false).addWalletBalanceDiscount(
            Provider.of<CheckoutState>(context, listen: false)
                .availableWalletBalance);
      }
    });

    _isPaymentOnline =
        Provider.of<CheckoutState>(context, listen: false).isPaymentOnline;
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _couponController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            if (Provider.of<CheckoutState>(context, listen: false)
                    .deliveryType ==
                2)
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9.0)),
                  color: Colors.red,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Você selecionou retirada",
                  style: AppStyle.whiteRegularText16Style(),
                ),
              ),
            Items(
              onDelete: () => onDelete(context),
            ),
          ],
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PriceResumeContainer(
                  useWalletBalance:
                      Provider.of<CheckoutState>(context).useWalletBalance,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                InputFieldsContainer(
                  commentController: _commentController,
                  couponController: _couponController,
                ),
                const SizedBox(height: 10.0),
                BottomScreenLargeButton(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  onPressed: (_) => onOrderButtonPressed(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      Text(
                        "FINALIZAR",
                        style: AppStyle.whiteSemiBoldText16Style(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
