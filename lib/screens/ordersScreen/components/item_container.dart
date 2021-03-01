import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/order_item.dart';

class ItemContainer extends StatelessWidget {
  final OrderItem item;
  final int index;
  final int itemCount;
  const ItemContainer({
    @required this.item,
    @required this.index,
    @required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (item.quantity > 1)
                    Text(
                      item.quantity.toString(),
                      style: AppStyle.greyRegularText16Style(),
                    ),
                  if (item.quantity > 1)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: const BoxDecoration(
                        color: AppStyle.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    item.name,
                    style: AppStyle.greyMediumText16Style(),
                  ),
                ],
              ),
              Text(
                "R\$ ${(double.parse(item.price) * item.quantity).toString()}",
                style: AppStyle.greyRegularText16Style(),
              ),
            ],
          ),
          if (itemCount > 1 && index < itemCount - 1)
            const Divider(
              color: AppStyle.lightGrey,
              height: 10,
            ),
        ],
      ),
    );
  }
}
