import 'package:geolocator/geolocator.dart';
import 'package:to_faminto_client/models/restaurant_delivery_data.dart';

class MinimalRestaurantData {
  final String imageUrl;
  final String description;
  final String name;
  final String slug;
  final String priceRange;
  final String deliveryCharge;
  final String deliveryTime;
  final int id;
  final int isFeatured;
  final int isActive;
  final RestaurantDeliveryData deliveryData;
  final bool acceptsOnlinePayment;
  final bool acceptsCardOnDelivery;

  /// 1 means delivery
  ///
  /// 2 means self pickup
  ///
  /// 3 means both
  final int deliveryType;

  const MinimalRestaurantData(
    this.imageUrl,
    this.description,
    this.name,
    this.slug,
    this.priceRange,
    this.deliveryCharge,
    this.deliveryTime,
    this.id,
    this.isFeatured,
    this.isActive,
    this.deliveryData,
    this.acceptsOnlinePayment,
    this.acceptsCardOnDelivery,
    this.deliveryType,
  );

  factory MinimalRestaurantData.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> clientAddressCoords) {
    final _deliveryData = RestaurantDeliveryData.fromJson(json);

    final _deliveryCharge = _calculateDeliveryCharge(
      clientAddressCoords: clientAddressCoords,
      deliveryData: _deliveryData,
    );

    final int priceForTwo = int.tryParse(json['price_range']) ??
        double.parse(json['price_range']).toInt();

    return MinimalRestaurantData(
      "https://www.tofaminto.com/${json['image']}",
      json['description'],
      json['name'],
      json['slug'],
      priceForTwo.toString(),
      _deliveryCharge.toStringAsFixed(2),
      json['delivery_time'],
      json['id'],
      json['is_featured'],
      json['is_active'],
      _deliveryData,
      json['accepts_online_payment'] == 1,
      json['accepts_card_on_delivery'] == 1,
      json['delivery_type'],
    );
  }

  static double _calculateDeliveryCharge({
    RestaurantDeliveryData deliveryData,
    Map<String, dynamic> clientAddressCoords,
  }) {
    final distanceBetweenRestaurantAndClient = Geolocator.distanceBetween(
      double.tryParse(deliveryData.latitude),
      double.tryParse(deliveryData.longitude),
      double.tryParse(clientAddressCoords['latitude']),
      double.tryParse(clientAddressCoords['longitude']),
    );

    if (deliveryData.deliveryChargeType != "DYNAMIC") {
      return deliveryData.deliveryCharge;
    }

    if (distanceBetweenRestaurantAndClient >
        deliveryData.baseDeliveryDistance) {
      final extraDistance = distanceBetweenRestaurantAndClient -
          deliveryData.baseDeliveryDistance;
      final extraCharge = (extraDistance / deliveryData.extraDeliveryDistance) *
          deliveryData.extraDeliveryCharge;
      return (deliveryData.baseDeliveryCharge + extraCharge).floorToDouble();
    } else {
      return deliveryData.baseDeliveryCharge;
    }
  }
}
