import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/card.dart';

class CardContainer extends StatelessWidget {
  final BankCard card;
  final double height;
  final EdgeInsetsGeometry margin;

  const CardContainer({@required this.card, this.height, this.margin})
      : assert(card != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      height: height ?? 232,
      padding: EdgeInsets.all(20.0),
      margin: margin,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.topRight,
          colors: [
            AppStyle.yellowGradientStart,
            AppStyle.yellowGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(26.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            card.isCredit ? "CREDITO" : "DEBITO",
            style: AppStyle.whiteBlackText24ItalicStyle(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "****",
                style: AppStyle.whiteRegularText30Style(),
              ),
              SizedBox(width: 15.0),
              Text(
                "****",
                style: AppStyle.whiteRegularText30Style(),
              ),
              SizedBox(width: 15.0),
              Text(
                "****",
                style: AppStyle.whiteRegularText30Style(),
              ),
              SizedBox(width: 15.0),
              Column(
                children: [
                  SizedBox(height: 2.6),
                  Text(
                    card.number,
                    style: AppStyle.whiteSemiBoldText16Style(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.holderName,
                style: AppStyle.whiteMediumText16Style(),
              ),
              Text(
                card.expireDate,
                style: AppStyle.whiteMediumText16Style(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
