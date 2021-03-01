import 'package:flutter/foundation.dart';

import 'addon.dart';

class CartAddon {
  final Addon addon;
  final int uniqueCartId;
  final int categoryId;
  final bool isDivisible;
  int divisions;
  double price;
  double originalPrice;
  int quantity;

  CartAddon({
    @required this.addon,
    @required this.uniqueCartId,
    @required this.categoryId,
    this.isDivisible,
    this.price,
    this.divisions,
    this.quantity = 1,
  });
}
