import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';

class PaymentMethodSwitch extends StatefulWidget {
  final bool isCurrentScreenOnline;
  final bool acceptsOnlinePayment;

  const PaymentMethodSwitch(
      {this.isCurrentScreenOnline, this.acceptsOnlinePayment});
  @override
  _PaymentMethodSwitchState createState() => _PaymentMethodSwitchState();
}

class _PaymentMethodSwitchState extends State<PaymentMethodSwitch> {
  bool _isOnline;

  void _switchToOnline(BuildContext context) {
    Provider.of<CheckoutState>(context, listen: false).isPaymentOnline = true;
    setState(() {
      _isOnline = true;
    });
  }

  void _switchToOffline(BuildContext context) {
    Provider.of<CheckoutState>(context, listen: false).isPaymentOnline = false;
    setState(() {
      _isOnline = false;
    });
  }

  @override
  void initState() {
    _isOnline =
        Provider.of<CheckoutState>(context, listen: false).isPaymentOnline ??
            false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isOnline = widget.isCurrentScreenOnline;
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        border: Border.all(color: Colors.grey[200], width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.acceptsOnlinePayment)
            Expanded(
              child: InkWell(
                onTap: () => _switchToOnline(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  decoration: _isOnline
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
                    "ONLINE",
                    style: _isOnline
                        ? AppStyle.whiteMediumTextStyle()
                        : AppStyle.greyMediumText14Style(),
                  ),
                ),
              ),
            ),
          Expanded(
            child: InkWell(
              onTap: () => _switchToOffline(context),
              child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: _isOnline
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
                  "ENTREGA",
                  style: _isOnline
                      ? AppStyle.greyMediumText14Style()
                      : AppStyle.whiteMediumTextStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
