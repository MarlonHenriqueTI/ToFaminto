class RestaurantDeliveryData {
  final String latitude;
  final String longitude;
  final double restaurantCharge;
  final double deliveryCharge;
  final String deliveryChargeType;
  final double baseDeliveryCharge;
  final int baseDeliveryDistance;
  final double extraDeliveryCharge;
  final int extraDeliveryDistance;
  final double minimalOrderPrice;

  const RestaurantDeliveryData({
    this.latitude,
    this.longitude,
    this.restaurantCharge,
    this.deliveryCharge,
    this.deliveryChargeType,
    this.baseDeliveryCharge,
    this.baseDeliveryDistance,
    this.extraDeliveryCharge,
    this.extraDeliveryDistance,
    this.minimalOrderPrice,
  });

  factory RestaurantDeliveryData.fromJson(Map<String, dynamic> json) {
    if (json['delivery_charge_type'] == "DYNAMIC") {
      return RestaurantDeliveryData(
        latitude: json['latitude'],
        longitude: json['longitude'],
        restaurantCharge: json['restaurant_charges'] != null
            ? double.parse(json['restaurant_charges'])
            : 0.0,
        deliveryChargeType: json['delivery_charge_type'],
        baseDeliveryCharge: double.parse(json['base_delivery_charge']),
        baseDeliveryDistance: json['base_delivery_distance'],
        extraDeliveryCharge: double.parse(json['extra_delivery_charge']),
        extraDeliveryDistance: json['extra_delivery_distance'],
        minimalOrderPrice: json['min_order_price'] != null
            ? double.parse(json['min_order_price'])
            : 0.0,
      );
    } else {
      return RestaurantDeliveryData(
        latitude: json['latitude'],
        longitude: json['longitude'],
        restaurantCharge: json['restaurant_charges'] != null
            ? double.parse(json['restaurant_charges'])
            : 0.0,
        deliveryCharge: json['delivery_charges'] != null
            ? double.parse(json['delivery_charges'])
            : 0.0,
        deliveryChargeType: json['delivery_charge_type'],
        minimalOrderPrice: json['min_order_price'] != null
            ? double.parse(json['min_order_price'])
            : 0.0,
      );
    }
  }
}
