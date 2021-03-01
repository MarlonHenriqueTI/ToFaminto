import 'package:flutter/foundation.dart';

class PlaceOrder {
  final int restaurantId;

  final String coupon;

  final String comment;

  /// COD or ONLINE
  final String paymentMethod;

  /// coordinates like {"lat": "11.553252", "lng": "43.2424242"}
  final Map<String, String> orderLocation;

  final int userId;

  /// "DeliveryAddress": {
  ///     "Street": "Rua Teste",
  ///     "Number": "123",
  ///     "Complement": "AP 123",
  ///     "ZipCode": "12345987",
  ///     "City": "Rio de Janeiro",
  ///     "State": "RJ",
  ///     "Country": "BRA"
  ///   }
  final Map<String, String> deliveryAddress;

  /// is useSavedCard is false then this should be null
  final int cardId;

  /// "items": [
  ///  {
  ///     "id": "itemId",
  ///     "quantity": 1,
  ///     "addonsIds": [1, 4, 5]
  ///   }
  /// ]
  final List<Map<String, dynamic>> items;

  final String securityCode;

  final int moneyChange;

  final int deliveryType;

  final bool useWalletBalance;

  const PlaceOrder({
    @required this.restaurantId,
    this.coupon,
    this.comment,
    @required this.paymentMethod,
    @required this.orderLocation,
    @required this.userId,
    @required this.deliveryAddress,
    @required this.cardId,
    @required this.items,
    this.securityCode,
    this.moneyChange,
    this.deliveryType,
    this.useWalletBalance,
  });
}
