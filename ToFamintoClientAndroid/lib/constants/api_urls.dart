class ApiUrls {
  static const _baseUrl = "https://tofaminto.com/public/api/";

  static const googlePlaceAutocompleteApiUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?";

  static const minimalRestaurantDataUrl = _baseUrl + "get-restaurants";

  static const restaurantDeliveryDataUrl =
      _baseUrl + "get-restaurant-info-lite/";

  static const restaurantItemsUrl = _baseUrl + "get-restaurant-items-lite/";

  static const orders = _baseUrl + "get-orders-lite";

  static const login = _baseUrl + "login";

  static const register = _baseUrl + "register";

  static const applyCoupon = _baseUrl + "apply-coupon";

  static const getAddresses = _baseUrl + "get-addresses";

  static const saveAddress = _baseUrl + "save-address-lite";

  static const deleteAddress = _baseUrl + "delete-address";

  static const saveCard = _baseUrl + "save-card";

  static const deleteCard = _baseUrl + "delete-card";

  static const getCards = _baseUrl + "get-cards";

  static const placeOrder = _baseUrl + "place-order-latest";

  static const addressToCoords = _baseUrl + "address-to-coordinate";

  static const placesPredictions = _baseUrl + "places-predictions";

  static const categories = _baseUrl + "get-all-restaurants-categories";

  static const filteredRestaurants = _baseUrl + "get-filtered-restaurants-lite";

  static const searchRestaurants = _baseUrl + "search-restaurants-lite";

  static const singleItemById = _baseUrl + "get-single-item-lite";

  static const walletTransactions = _baseUrl + "get-wallet-transactions";

  static const promoSlider = _baseUrl + "promo-slider-lite";

  static const saveNotificationToken = _baseUrl + "save-notification-token";

  static const getOrderMessages = _baseUrl + "get-order-messages";

  static const sendMessage = _baseUrl + "send-order-message";
}
