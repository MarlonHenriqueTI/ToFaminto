import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';

class DeliveryPaymentMethodSwitch extends StatefulWidget {
  final bool isCurrentScreenOnline;

  const DeliveryPaymentMethodSwitch({this.isCurrentScreenOnline});
  @override
  _DeliveryPaymentMethodSwitchState createState() =>
      _DeliveryPaymentMethodSwitchState();
}

class _DeliveryPaymentMethodSwitchState
    extends State<DeliveryPaymentMethodSwitch> {
  bool _isCash;
  bool _acceptsCardPayment;

  void _switchToCash(BuildContext context) {
    Provider.of<CheckoutState>(context, listen: false).isPaymentCash = true;
    setState(() {
      _isCash = true;
    });
  }

  void _switchToCard(BuildContext context) {
    Provider.of<CheckoutState>(context, listen: false).isPaymentCash = false;
    setState(() {
      _isCash = false;
    });
  }

  @override
  void initState() {
    _acceptsCardPayment = Provider.of<RoutesState>(context, listen: false)
            .currentSelectedRestaurantMinData
            ?.acceptsCardOnDelivery ??
        false;
    _isCash =
        Provider.of<CheckoutState>(context, listen: false).isPaymentCash ??
            false;

    if (_acceptsCardPayment == false) _isCash = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _acceptsCardPayment = Provider.of<RoutesState>(context, listen: false)
            .currentSelectedRestaurantMinData
            ?.acceptsCardOnDelivery ??
        false;
    _isCash =
        Provider.of<CheckoutState>(context, listen: false).isPaymentCash ??
            false;

    if (_acceptsCardPayment == false) _isCash = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        border: Border.all(color: Colors.grey[200], width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_acceptsCardPayment)
            Expanded(
              child: InkWell(
                onTap: () => _switchToCard(context),
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  decoration: _isCash ?? false
                      ? null
                      : const BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.topRight,
                            colors: [
                              AppStyle.yellowGradientStart,
                              AppStyle.yellowGradientEnd,
                            ],
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                        ),
                  child: Text(
                    "CARTÃO",
                    style: _isCash ?? false
                        ? AppStyle.greyMediumText14Style()
                        : AppStyle.whiteMediumTextStyle(),
                  ),
                ),
              ),
            ),
          Expanded(
            child: InkWell(
              onTap: () => _switchToCash(context),
              child: Container(
                alignment: Alignment.center,
                height: 45,
                decoration: _isCash ?? false
                    ? const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.topRight,
                          colors: [
                            AppStyle.yellowGradientStart,
                            AppStyle.yellowGradientEnd,
                          ],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                      )
                    : null,
                child: Text(
                  "DINHEIRO",
                  style: _isCash ?? false
                      ? AppStyle.whiteMediumTextStyle()
                      : AppStyle.greyMediumText14Style(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
