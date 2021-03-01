import 'package:flutter/foundation.dart';

import 'addon.dart';
import 'cart_addon.dart';
import 'item.dart';

class CartItem {
  final Item item;
  final int uniqueCartId;
  bool isTemporary;
  int quantity;
  List<CartAddon> _cartAddons = [];

  double get totalPrice {
    double totalPrice = double.parse(item.price);
    for (final addon in _cartAddons) {
      totalPrice += addon.price * addon.quantity;
    }
    return totalPrice;
  }

  List<CartAddon> get cartAddons => _cartAddons;

  CartItem({
    @required this.item,
    @required this.uniqueCartId,
    this.quantity = 1,
    this.isTemporary = true,
  });

  Iterable<List<int>> addons() sync* {
    for (final cartAddon in _cartAddons) {
      yield [cartAddon.addon.id, cartAddon.divisions ?? 1];
    }
  }

  List<int> addonsIds() {
    List<int> _addonsIds = [];
    for (final cartAddon in _cartAddons) {
      _addonsIds.add(cartAddon.addon.id);
    }
    return _addonsIds;
  }

  int increaseItemAmount() {
    quantity++;
    return quantity;
  }

  int decreaseItemAmount() {
    if (quantity > 1) {
      quantity--;
      return quantity;
    }
    return 0;
  }

  int getAddonAmount(Addon addon, int addonCategoryId) {
    CartAddon _cartAddon = _cartAddons.firstWhere(
        (element) => (element.addon.id == addon.id &&
            element.categoryId == addonCategoryId),
        orElse: () => null);
    if (_cartAddon != null) {
      return _cartAddon.quantity;
    }
    return 0;
  }

  CartAddon addAddon(Addon addon, int addonCategoryId) {
    CartAddon _cartAddon = _cartAddons.firstWhere(
        (element) => (element.addon.id == addon.id &&
            element.categoryId == addonCategoryId),
        orElse: () => null);

    if (_cartAddon != null) {
      _cartAddon.quantity++;
      return _cartAddon;
    } else {
      _cartAddons.add(CartAddon(
        isDivisible: addon.isDivisible,
        divisions: addon.divisions,
        price: double.parse(addon.price),
        categoryId: addonCategoryId,
        addon: addon,
        uniqueCartId: int.parse(addon.id.toString() +
            DateTime.now().millisecondsSinceEpoch.toString()),
      ));

      if (addon.isDivisible) {
        final _sameCategoryDivisibleItems = _cartAddons.where((element) =>
            element.isDivisible && element.categoryId == addonCategoryId);

        if (_sameCategoryDivisibleItems.length > 1) {
          for (final addon in _sameCategoryDivisibleItems) {
            addon.divisions = _sameCategoryDivisibleItems.length;
            addon.price /= (_sameCategoryDivisibleItems.length);
          }
        }
      }

      return _cartAddons.firstWhere(
          (element) => (element.addon.id == addon.id &&
              element.categoryId == addonCategoryId),
          orElse: () => null);
    }
  }

  int removeAddon(Addon addon, int addonCategoryId) {
    if (addon.isDivisible) {
      final _sameCategoryDivisibleItems = _cartAddons.where((element) =>
          element.isDivisible && element.categoryId == addonCategoryId);

      if (_sameCategoryDivisibleItems.isNotEmpty) {
        addon.divisions = _sameCategoryDivisibleItems.length;

        for (final addon in _sameCategoryDivisibleItems) {
          addon.price *= 2;
        }
      }
    }

    CartAddon _cartAddon = _cartAddons.firstWhere(
        (element) => element.addon.id == addon.id,
        orElse: () => null);

    if (_cartAddon != null) {
      if (_cartAddon.quantity > 1) {
        _cartAddon.quantity--;
        return _cartAddon.quantity;
      } else {
        _cartAddons.removeWhere((element) => (element.addon.id == addon.id &&
            element.categoryId == addonCategoryId));
      }
    }
    return 0;
  }

  void removeAllAddonsFromCategory(int addonCategoryId) {
    final cartAddonsToRemove =
        _cartAddons.where((element) => element.categoryId == addonCategoryId);
    for (final cartAddon in cartAddonsToRemove.toList()) {
      _cartAddons.remove(cartAddon);
    }
  }
}
