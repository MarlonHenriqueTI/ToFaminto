import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_faminto_client/models/cart_item.dart';
import 'package:to_faminto_client/models/coupon.dart';
import 'package:to_faminto_client/models/placeOrder.dart';
import 'package:to_faminto_client/models/user.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/services/api_service.dart';

class CheckoutState extends ChangeNotifier {
  ApiService _apiService = ApiService();
  List<UserAddress> _allAddresses;
  int selectedRestaurantId;
  int selectedAddressId;
  int selectedCardId;
  int selectedCardIndex;
  int currentScreenIndex;
  bool _isPaymentOnline;
  bool _isPaymentCash;
  int moneyChange;
  Coupon selectedCoupon;
  int deliveryType;
  List<CartItem> cartItems;
  double availableWalletBalance;
  bool useWalletBalance;
  bool isCreditCard;

  CheckoutState()
      : currentScreenIndex = 0,
        _isPaymentOnline = false,
        _isPaymentCash = true,
        availableWalletBalance = 0.0,
        useWalletBalance = false,
        _allAddresses = [];

  List<UserAddress> get allAddresses => _allAddresses;

  get isPaymentOnline => _isPaymentOnline;
  get isPaymentCash => _isPaymentCash;

  set isPaymentOnline(bool isPaymentOnline) {
    _isPaymentOnline = isPaymentOnline;
    notifyListeners();
  }

  set isPaymentCash(bool isPaymentCash) {
    _isPaymentCash = isPaymentCash;
    _isPaymentOnline = false;
    notifyListeners();
  }

  void fetchAddresses() async {
    final _prefs = await SharedPreferences.getInstance();
    var addresses = _prefs.getStringList("addresses");
    if (addresses == null) return null;

    _allAddresses = [];
    for (final address in addresses) {
      _allAddresses.add(UserAddress.fromPrefs(jsonDecode(address)));
    }
    notifyListeners();
  }

  void resetState() {
    _allAddresses = [];
    currentScreenIndex = 0;
    selectedAddressId = null;
    selectedCardIndex = null;
    selectedCardId = null;
    isPaymentOnline = false;
  }

  void changeToCardScreen() {
    currentScreenIndex = 0;
    notifyListeners();
  }

  void changeToResumeScreen() {
    currentScreenIndex = 1;
    notifyListeners();
  }

  void changeToScreenByIndex(int index) {
    if (index >= 0 && index <= 1 && currentScreenIndex != index) {
      currentScreenIndex = index;
    }
    notifyListeners();
  }

  void assignCard({int id, int index}) {
    selectedCardId = id;
    selectedCardIndex = index;
  }

  Future<Coupon> applyCoupon({String coupon, int resId}) async {
    final result = await _apiService.applyCoupon(
      couponCode: coupon,
      restaurantId: resId,
    );

    if (result != false) {
      selectedCoupon = Coupon.fromJson(result);

      //notifyListeners();
      return selectedCoupon;
    }
    return null;
  }

  List<Map<String, dynamic>> checkoutItems() {
    List<Map<String, dynamic>> checkoutItems = [];

    for (final cartItem in cartItems) {
      checkoutItems.add(
        {
          "id": cartItem.item.id,
          "quantity": cartItem.quantity,
          "addons": cartItem.addons().toList(),
        },
      );
    }

    return checkoutItems;
  }

  Future<dynamic> placeOrder({
    @required User user,
    @required UserAddress address,
    String securityCode,
    String comment,
  }) async {
    return await _apiService.placeOrder(
      PlaceOrder(
          restaurantId: selectedRestaurantId,
          coupon: selectedCoupon?.code,
          comment: comment ?? "",
          deliveryType: deliveryType,
          useWalletBalance: useWalletBalance,
          paymentMethod: isPaymentOnline ?? false
              ? "PAGO ONLINE"
              : isPaymentCash ?? true
                  ? "DINHEIRO NA ENTREGA"
                  : isCreditCard ?? false
                      ? "CREDITO NA ENTREGA"
                      : "DEDIBO NA ENTREGA",
          orderLocation: {
            "lat": address.latitude,
            "lng": address.longitude,
            "address": address.readableFullAddress(),
          },
          userId: user.id,
          deliveryAddress: address.transactionDeliveryAddress(),
          cardId: selectedCardId,
          items: checkoutItems(),
          securityCode: securityCode,
          moneyChange: moneyChange),
    );
  }
}

class CheckoutItem {
  final int id;
  final int quantity;
  final List<int> addonsIds;

  const CheckoutItem({
    @required this.id,
    @required this.quantity,
    @required this.addonsIds,
  });
}
