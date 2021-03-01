import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/item.dart';

class IngredientsContainer extends StatelessWidget {
  final Item item;
  const IngredientsContainer({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        border: Border.all(
          color: Colors.grey[200],
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item.description != null
              ? Text(
                  'Ingredientes',
                  style: AppStyle.mediumGreyMediumText16Style(),
                )
              : SizedBox(),
          SizedBox(height: 15.0),
          item.description != null
              ? Text(
                  item.description ?? "Nada por aqui...",
                  style: AppStyle.greyRegularText15Style(),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
