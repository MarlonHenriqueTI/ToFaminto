import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/order.dart';
import 'package:to_faminto_client/models/order_item.dart';

import 'item_container.dart';

class OrderContainer extends StatelessWidget {
  final Order order;
  final int index;
  final Function openChat;

  List<ItemContainer> buildItems(List<OrderItem> items) {
    List<ItemContainer> itemContainers = [];

    for (int i = 0; i < items.length; i++) {
      itemContainers.add(
        ItemContainer(
          item: items[i],
          index: i,
          itemCount: items.length,
        ),
      );
    }
    return itemContainers;
  }

  OrderContainer({this.order, this.index, this.openChat});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(index.toString()),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(9.0)),
        border: Border.all(
          color: AppStyle.lightGrey,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.uniqueId.toString(),
                    style: AppStyle.greyRegularText16Style(),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    order.restaurantName,
                    style: AppStyle.mediumGreyMediumText16Style(),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        order.createdAt,
                        style: AppStyle.greyRegularText16Style(),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        order.status.toString(),
                        style: AppStyle.greyRegularText16Style(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: R\$ ${order.price}",
                        style: AppStyle.greyRegularText16Style(),
                      ),
                    ],
                  ),
                ],
              ),
              if (order.restaurantLogo != null)
                Container(
                  height: 55.0,
                  width: 55.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(order.restaurantLogo, scale: 100),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: buildItems(order.items),
          ),
          if (order.statusId == 7 || order.statusId < 5)
            GestureDetector(
              onTap: () => openChat(order),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: AppStyle.yellow),
                ),
                alignment: Alignment.center,
                child: Text(
                  'CHAT',
                  style: AppStyle.greyMediumText16Style(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
