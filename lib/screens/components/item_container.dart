import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/item.dart';

class ItemContainer extends StatelessWidget {
  final Item item;

  const ItemContainer({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(9.0)),
        border: Border.all(
          color: AppStyle.lightGrey,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (item.image != null)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item.image, scale: 100),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 20.0),
                Flexible(
                  child: Text(
                    item.name,
                    style: AppStyle.mediumGreyMediumText16Style(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.price == "0.00" ? "" : "R\$ ${item.price}",
            style: AppStyle.greyMediumText16Style(),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
