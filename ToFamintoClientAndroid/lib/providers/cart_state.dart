import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_faminto_client/models/cart_addon.dart';
import 'package:to_faminto_client/models/cart_item.dart';
import 'package:to_faminto_client/models/coupon.dart';
import 'package:to_faminto_client/models/item.dart';

import '../models/addon.dart';

class CartState extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _storeDeliveryTax = 0;
  double _storeTax = 0;
  int restaurantId;
  double _totalCartValue = 0;
  double discountAmount;
  double _walletBalance = 0;
  double walletDiscount;

  void clearTemporaryItems() {
    _cartItems.removeWhere((element) => element.isTemporary);
  }

  void setDeliveryTax(double value) {
    _storeDeliveryTax = value;
  }

  double subtotalCartValue() {
    double totalValue = 0;
    for (CartItem cartItem in _cartItems) {
      totalValue += (cartItem.totalPrice * cartItem.quantity);
    }
    return totalValue;
  }

  double deliveryCharge() {
    return _storeDeliveryTax;
  }

  double storeCharge() {
    return _storeTax;
  }

  double get bruteTotalCartValue {
    return subtotalCartValue() + _storeDeliveryTax + _storeTax;
  }

  double get liquidTotalCartValue {
    double bruteValue = (subtotalCartValue() + _storeDeliveryTax + _storeTax);
    if (discountAmount != 0 && discountAmount != null) {
      if (discountAmount >= bruteValue) return 0;
      bruteValue -= discountAmount;
    }
    if (_walletBalance != 0 && _walletBalance != null) {
      if (_walletBalance >= bruteValue) {
        walletDiscount = bruteValue;
        return 0;
      }
      walletDiscount = _walletBalance;
      bruteValue -= _walletBalance;
    }
    return bruteValue;
  }

  List<CartItem> get cartItems {
    clearTemporaryItems();
    return _cartItems;
  }

  int get itemCount => _cartItems.length;

  CartItem _getCartItem(int uniqueCartItemId) {
    return _cartItems.firstWhere(
        (element) => element.uniqueCartId == uniqueCartItemId,
        orElse: () => null);
  }

  bool setItemToPerm(int uniqueCartItemId) {
    CartItem cartItem = _getCartItem(uniqueCartItemId);
    if (cartItem.totalPrice == 0) return false;
    if (double.tryParse(cartItem.item.price) == 0.0 &&
        cartItem.cartAddons.isEmpty) return false;
    cartItem.isTemporary = false;
    return true;
  }

  CartItem getCartItemByUniqueId(int uniqueCartItemId) {
    return _cartItems.firstWhere(
        (element) => element.uniqueCartId == uniqueCartItemId,
        orElse: () => null);
  }

  dynamic getAddonAmountByUniqueCartItemId(
      Addon addon, int uniqueCartItemId, int addonCategoryId) {
    CartItem _cartItem = _getCartItem(uniqueCartItemId);
    if (_cartItem != null) {
      return _cartItem.getAddonAmount(addon, addonCategoryId);
    }
    return 0;
  }

  /// -1 means different stores
  int addNewItem(Item item, double storeTax) {
    if (_cartItems.isEmpty ||
        item.restaurantSlug == _cartItems.first.item.restaurantSlug) {
      int id = item.id + DateTime.now().millisecondsSinceEpoch;
      _cartItems.add(
        CartItem(
          item: item,
          uniqueCartId: id,
        ),
      );
      _storeTax = storeTax;
      notifyListeners();
      return id;
    }
    return -1;
  }

  void removeItem(int uniqueCartId) {
    _cartItems.removeWhere((element) => element.uniqueCartId == uniqueCartId);
  }

  CartAddon addAddon(int uniqueCartItemId, Addon addon, int addonCategoryId,
      int maxAddonAmount) {
    CartItem cartItem = _getCartItem(uniqueCartItemId);
    if (cartItem != null) {
      if (maxAddonAmount != 0) {
        final sameCategoryAddons = cartItem.cartAddons
            .where((element) => element.categoryId == addonCategoryId);

        int amount = 0;
        if (sameCategoryAddons.isNotEmpty) {
          for (final addon in sameCategoryAddons) {
            amount += addon.quantity;
          }
          if (amount == maxAddonAmount) return null;
        }
      }
      return cartItem.addAddon(addon, addonCategoryId);
    }
    return null;
  }

  int removeAddon(int uniqueCartItemId, Addon addon, int addonCategoryId) {
    CartItem cartItem = _getCartItem(uniqueCartItemId);
    if (cartItem != null) {
      return cartItem.removeAddon(addon, addonCategoryId);
    }
    return 0;
  }

  int increaseItemAmount(int uniqueCartItemId) {
    CartItem cartItem = _getCartItem(uniqueCartItemId);
    if (cartItem != null) {
      return cartItem.increaseItemAmount();
    }
    return 404;
  }

  int decreaseItemAmount(int uniqueCartItemId) {
    CartItem cartItem = _getCartItem(uniqueCartItemId);
    if (cartItem != null) {
      if (cartItem.quantity > 1) {
        return cartItem.decreaseItemAmount();
      }
      _cartItems
          .removeWhere((element) => element.uniqueCartId == uniqueCartItemId);
      notifyListeners();
      return 0;
    }
    return 404;
  }

  /// Clears all items on the cart and resets the tax to zero
  void clearCart() {
    _cartItems = [];
    _storeDeliveryTax = 0;
    _storeTax = 0;
    discountAmount = null;
    _totalCartValue = 0;
  }

  bool swapItem(int uniqueCartItemId, Addon addon, int addonCategoryId) {
    CartItem cartItem = _getCartItem(uniqueCartItemId);
    final bool clickedSameItem =
        cartItem.cartAddons.any((cartAddon) => cartAddon.addon.id == addon.id);
    cartItem?.removeAllAddonsFromCategory(addonCategoryId);
    if (!clickedSameItem) cartItem?.addAddon(addon, addonCategoryId);
    return clickedSameItem;
  }

  bool checkOne(
      int uniqueCartItemId, Addon addon, int addonCategoryId, bool canAdd) {
    CartItem cartItem = _getCartItem(uniqueCartItemId);
    final bool clickedSameItem =
        cartItem.cartAddons.any((cartAddon) => cartAddon.addon.id == addon.id);
    if (clickedSameItem) {
      cartItem?.removeAddon(addon, addonCategoryId);
    } else {
      if (canAdd) {
        cartItem?.addAddon(addon, addonCategoryId);
      }
    }
    return clickedSameItem;
  }

  void applyCoupon(Coupon coupon) {
    if (_hasDiscountApplied()) removeDiscount();

    if (coupon.isTypeAmount()) {
      discountAmount = coupon.amount;
    } else {
      discountAmount = (_totalCartValue / 100) * coupon.amount;
    }

    notifyListeners();
  }

  bool _hasDiscountApplied() => discountAmount != null;

  void removeDiscount() {
    discountAmount = null;
    notifyListeners();
  }

  void removeAllDiscounts() {
    _walletBalance = null;
    walletDiscount = null;
    discountAmount = null;
    notifyListeners();
  }

  void addWalletBalanceDiscount(double walletBalance) {
    _walletBalance = walletBalance;
    notifyListeners();
  }

  void removeWalletBalanceDiscount() {
    _walletBalance = null;
    walletDiscount = null;
    notifyListeners();
  }
}
