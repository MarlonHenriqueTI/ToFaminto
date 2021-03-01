import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/cart_state.dart';

class PriceResumeContainer extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool useWalletBalance;

  const PriceResumeContainer({
    this.padding,
    this.useWalletBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding != null
          ? padding
          : const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sub-total",
                style: AppStyle.greyRegularText16Style(),
              ),
              Text(
                "R\$ ${Provider.of<CartState>(context).subtotalCartValue().toStringAsFixed(2)}",
                style: AppStyle.greyRegularText16Style(),
              ),
            ],
          ),
          if (Provider.of<CartState>(context).storeCharge() != 0)
            const SizedBox(height: 5),
          if (Provider.of<CartState>(context).storeCharge() != 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Embalagem",
                  style: AppStyle.greyRegularText16Style(),
                ),
                Text(
                  "R\$ ${Provider.of<CartState>(context).storeCharge().toStringAsFixed(2)}",
                  style: AppStyle.greyRegularText16Style(),
                ),
              ],
            ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Entrega",
                style: AppStyle.greyRegularText16Style(),
              ),
              Text(
                "R\$ ${Provider.of<CartState>(context).deliveryCharge().toStringAsFixed(2)}",
                style: AppStyle.greyRegularText16Style(),
              ),
            ],
          ),
          Consumer<CartState>(builder: (context, checkout, _) {
            return Column(
              children: [
                if (checkout.discountAmount != null) SizedBox(height: 5),
                if (checkout.discountAmount != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cupom",
                        style: AppStyle.greyRegularText16Style(),
                      ),
                      Text(
                        "-R\$ ${checkout.discountAmount.toStringAsFixed(2)}",
                        style: AppStyle.greyRegularText16Style(),
                      ),
                    ],
                  ),
                if (checkout.walletDiscount != null) SizedBox(height: 5),
                if (checkout.walletDiscount != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Carteira Digital",
                        style: AppStyle.greyRegularText16Style(),
                      ),
                      Text(
                        "-R\$ ${checkout.walletDiscount.toStringAsFixed(2)}",
                        style: AppStyle.greyRegularText16Style(),
                      ),
                    ],
                  ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: AppStyle.greyMediumText20Style(),
                    ),
                    Text(
                      "R\$ ${checkout.liquidTotalCartValue.toStringAsFixed(2)}",
                      style: AppStyle.greyMediumText20Style(),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
