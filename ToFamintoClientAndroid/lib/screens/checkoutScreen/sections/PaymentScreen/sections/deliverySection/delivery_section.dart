import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'delivery_payment_method_switch.dart';
import 'money_change_widget.dart';

class DeliverySection extends StatelessWidget {
  const DeliverySection({
    Key key,
    @required TextEditingController moneyChangeController,
  })  : _moneyChangeController = moneyChangeController,
        super(key: key);

  final TextEditingController _moneyChangeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer<CheckoutState>(builder: (context, checkout, _) {
          if (checkout.isPaymentCash) {
            return MoneyChangeWidget(
              moneyChangeController: _moneyChangeController,
            );
          } else {
            return TypeOfCardWidget();
          }
        }),
        DeliveryPaymentMethodSwitch(),
      ],
    );
  }
}

class TypeOfCardWidget extends StatefulWidget {
  @override
  _TypeOfCardWidgetState createState() => _TypeOfCardWidgetState();
}

class _TypeOfCardWidgetState extends State<TypeOfCardWidget> {
  bool _isCreditCard;

  void _switchToCredit(BuildContext context) {
    Provider.of<CheckoutState>(context, listen: false).isCreditCard = true;
    setState(() {
      _isCreditCard = true;
    });
  }

  void _switchToDebit(BuildContext context) {
    Provider.of<CheckoutState>(context, listen: false).isCreditCard = false;
    setState(() {
      _isCreditCard = false;
    });
  }

  @override
  void initState() {
    _isCreditCard =
        Provider.of<CheckoutState>(context, listen: false).isCreditCard ??
            false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        border: Border.all(color: AppStyle.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _switchToCredit(context),
              child: Container(
                alignment: Alignment.center,
                height: 45,
                decoration: _isCreditCard
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
                  "CRÉDITO",
                  style: _isCreditCard
                      ? AppStyle.whiteMediumTextStyle()
                      : AppStyle.greyMediumText14Style(),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _switchToDebit(context),
              child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: _isCreditCard
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
                  "DÉBITO",
                  style: _isCreditCard
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
