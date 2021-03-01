import 'package:geolocator/geolocator.dart';
import 'package:to_faminto_client/models/restaurant_delivery_data.dart';

double deliveryCharge(
    RestaurantDeliveryData deliveryData,
    Map<String, double> restaurantCoords,
    Map<String, double> clientAddressCoords) {
  final distanceBetweenRestaurantAndClient = Geolocator.distanceBetween(
    restaurantCoords['latitude'],
    restaurantCoords['longitude'],
    restaurantCoords['latitude'],
    restaurantCoords['longitude'],
  );

  if (distanceBetweenRestaurantAndClient > deliveryData.baseDeliveryDistance) {
    final extraDistance =
        distanceBetweenRestaurantAndClient - deliveryData.baseDeliveryDistance;
    final extraCharge = extraDistance /
        deliveryData.extraDeliveryDistance *
        deliveryData.extraDeliveryCharge;
    return deliveryData.baseDeliveryCharge + extraCharge;
  }

  return deliveryData.baseDeliveryCharge;
}
