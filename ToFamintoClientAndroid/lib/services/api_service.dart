import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_faminto_client/constants/general_constants.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/card.dart';
import 'package:to_faminto_client/models/filter.dart';
import 'package:to_faminto_client/models/minimal_restaurant_data.dart';
import 'package:to_faminto_client/models/order.dart';
import 'package:to_faminto_client/models/order_message.dart';
import 'package:to_faminto_client/models/placeOrder.dart';
import 'package:to_faminto_client/models/promo_slider.dart';
import 'package:to_faminto_client/models/query_item.dart';
import 'package:to_faminto_client/models/user.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/models/wallet.dart';
import '../constants/api_urls.dart';

class ApiService {
  Dio dioPersistentConnection;

  Future<Map<String, dynamic>> _getIdAndToken() async {
    final _prefs = await SharedPreferences.getInstance();

    final authToken = _prefs.getString('authToken');
    final id = _prefs.getString('id');

    return {"id": id, "token": authToken};
  }

  Future<Map<String, dynamic>> _makeRequest(
      {String url, Map body, int timeOut}) async {
    try {
      Response response = await Dio().post(url,
          data: body,
          options: Options(
            sendTimeout: timeOut ?? GeneralConstants.API_SEND_TIMEOUT,
            receiveTimeout: timeOut ?? GeneralConstants.API_RECEIVE_TIMEOUT,
          ));
      return {
        'isSuccess': true,
        'data': response.data,
      };
    } on DioError catch (e) {
      return {
        'isSuccess': false,
        'data': ApiError.fromDioError(e),
      };
    }
  }

  Future<dynamic> minimalRestaurantData(Map coordinates,
      {List<int> selectedFilters, String query}) async {
    if (selectedFilters != null) {
      return getFilteredRestaurants(
        selectedFilters: selectedFilters,
        latitude: coordinates['latitude'],
        longitude: coordinates['longitude'],
      );
    } else {
      final response = await _makeRequest(
          url: ApiUrls.minimalRestaurantDataUrl, body: coordinates);
      return response['data'];
    }
  }

  Future<Map> restaurantItems(String slug) {
    return _makeRequest(url: ApiUrls.restaurantItemsUrl + slug);
  }

  Future<dynamic> orders() async {
    bool isLoggedIn;

    final _prefs = await SharedPreferences.getInstance();

    final authToken = _prefs.get('authToken');
    final id = _prefs.get('id');

    if (authToken != null && id != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    if (isLoggedIn) {
      final response = await _makeRequest(
        url: ApiUrls.orders,
        body: {
          "token": authToken,
          "user_id": id,
        },
      );
      if (response['isSuccess']) {
        List<Order> _orders = [];
        for (final order in response['data']) {
          _orders.add(Order.fromJson(order));
        }
        return _orders;
      } else {
        return response['data'];
      }
    }
    return null;
  }

  Future<dynamic> login({String email, String password}) async {
    Map body = {
      "name": null,
      "email": email,
      "password": password,
      "accessToken": null,
      "phone": null,
      "provider": null,
      "address": null
    };

    final response = await _makeRequest(url: ApiUrls.login, body: body);
    if (response['isSuccess'] && response['data']['success']) {
      User _user = User.fromJson(response['data']['data']);

      final _prefs = await SharedPreferences.getInstance();

      _prefs.setString('authToken', _user.authToken);
      _prefs.setString('id', _user.id.toString());

      return _user;
    } else {
      return response['data'];
    }
  }

  Future<dynamic> register(
      {String name, String email, String phone, String password}) async {
    Map body = {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "address": null
    };

    final response = await _makeRequest(url: ApiUrls.register, body: body);
    if (response['isSuccess']) {
      if (response['data']['success'] ?? false) {
        User _user = User.fromJson(response['data']['data']);

        final _prefs = await SharedPreferences.getInstance();

        _prefs.setString('authToken', _user.authToken);
        _prefs.setString('id', _user.id.toString());

        return _user;
      } else if (response['data']['email_phone_already_used']) {
        return "Celular já cadastrado";
      }
    } else {
      return response['data'];
    }
  }

  Future<dynamic> applyCoupon({String couponCode, int restaurantId}) async {
    Map body = {
      "coupon": couponCode,
      "restaurant_id": restaurantId,
    };
    final response = await _makeRequest(url: ApiUrls.applyCoupon, body: body);
    if (response["isSuccess"]) {
      return response['data'];
    } else {
      return false;
    }
  }

  Future<dynamic> getAddresses() async {
    var idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;

    if (idAndToken['token'] != null) {
      Map body = {
        "user_id": idAndToken['id'],
        "token": idAndToken['token'],
        "restaurant_id": null,
      };
      final response =
          await _makeRequest(url: ApiUrls.getAddresses, body: body);
      return response['data'];
    } else {
      return null;
    }
  }

  Future<BankCard> saveCard(
    String customerName,
    String cardNumber,
    String holder,
    String expirationDate,
    String cpf,
    String brand,
    String type,
  ) async {
    var idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;

    Map body = {
      "token": idAndToken['token'],
      "CustomerName": customerName,
      "CardNumber": cardNumber,
      "Holder": holder,
      "ExpirationDate": expirationDate,
      "FiscalId": cpf,
      "Brand": brand,
      "CardType": type,
    };

    final response = await _makeRequest(url: ApiUrls.saveCard, body: body);

    if (response["isSuccess"]) {
      return BankCard(
        id: response["data"]["cardId"],
        holderName: holder,
        number: cardNumber.substring(cardNumber.length - 4),
        expireDate: expirationDate,
        isCredit: type == "CreditCard" ? true : false,
      );
    } else {
      return null;
    }
  }

  Future<bool> deleteCard(int id) async {
    var idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;

    Map body = {
      "token": idAndToken['token'],
      "id": id,
    };

    final response = await _makeRequest(url: ApiUrls.deleteCard, body: body);

    if (response["isSuccess"]) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> getCards() async {
    var idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;

    if (idAndToken['token'] != null) {
      Map body = {
        "token": idAndToken['token'],
      };
      final response = await _makeRequest(url: ApiUrls.getCards, body: body);

      return response['data'];
    } else {
      return null;
    }
  }

  Future<bool> placeOrder(PlaceOrder order) async {
    var idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;
    Map body = {
      "token": idAndToken['token'],
      "restaurantId": order.restaurantId,
      "coupon": order.coupon,
      "paymentMethod": order.paymentMethod,
      "useWalletBalance": order.useWalletBalance,
      "comment": order.comment,
      "orderLocation": order.orderLocation,
      "moneyChange": order.moneyChange,
      "deliveryType": order.deliveryType,
      "user": {
        "id": order.userId,
        "customer": {
          "DeliveryAddress": order.deliveryAddress,
        },
        "cardId": order.cardId,
        "cardInfo": {
          "SecurityCode": order.securityCode,
        }
      },
      "items": order.items,
    };

    final response = await _makeRequest(url: ApiUrls.placeOrder, body: body);
    if (response["data"]["success"]) {
      return true;
    } else {
      return response["data"];
    }
  }

  Future<int> saveAddress({UserAddress address}) async {
    var idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;

    Map body = {
      "token": idAndToken['token'],
      "latitude": address.latitude,
      "longitude": address.longitude,
      "address": address.readableFullAddress(),
      "house": address.doorNumber,
      "tag": address.type,
      "complement": address.complement ?? "",
    };

    final response = await _makeRequest(url: ApiUrls.saveAddress, body: body);

    if (response["isSuccess"]) {
      return response['data'];
    } else {
      return null;
    }
  }

  Future<bool> deleteAddress({UserAddress address}) async {
    var idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;

    Map body = {
      "token": idAndToken['token'],
      "user_id": address.userId,
      "address_id": address.id,
    };

    final response = await _makeRequest(url: ApiUrls.deleteAddress, body: body);
    if (response["isSuccess"]) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> addressToCoords({UserAddress address}) async {
    Map body = {
      "string": address.conversionAddress(),
    };

    final response =
        await _makeRequest(url: ApiUrls.addressToCoords, body: body);

    if (response["isSuccess"]) {
      return {
        "lat": response["data"]["lat"],
        "lng": response["data"]["lng"],
      };
    } else {
      return response['data'];
    }
  }

  Future<dynamic> addressAutoComplete({String query, String token}) async {
    query = query.replaceAll(" ", "+");

    String key = "key=AIzaSyB4X6ntDsb6eQOQ7EMJD71Jgdhg9SgHCkY";
    String sessiontoken = "sessiontoken=$token";
    String input = "input=$query";
    String language = "language=pt-BR";
    String types = "types=address";
    String components = "components=country:br";

    Map body = {
      "parameters": "$input&$types&$language&$components&$key&$sessiontoken",
    };

    final response = await _makeRequestToPersistentConnection(
        url: ApiUrls.placesPredictions, body: body);

    if (response["isSuccess"]) {
      List<Map<String, dynamic>> predictions = [];
      if (response['data']['status'] == "OK") {
        for (final prediction in response['data']['predictions']) {
          predictions.add({
            "description": prediction['description'],
            "terms": prediction['terms']
          });
        }
      }
      return predictions;
    } else if (!response["isSuccess"]) {
      return response['data'];
    }
    return null;
  }

  void openConnection(String url) async {
    if (dioPersistentConnection != null) return;
    dioPersistentConnection = Dio();
    dioPersistentConnection.options.baseUrl = url;
    dioPersistentConnection.options.connectTimeout = 1000 * 60;
  }

  void closeConnection() async {
    if (dioPersistentConnection == null) return;
    dioPersistentConnection.close();
  }

  Future<Map> _makeRequestToPersistentConnection({String url, Map body}) async {
    if (dioPersistentConnection == null)
      return {'isSuccess': false, 'data': {}};
    try {
      Response response = await dioPersistentConnection.post(url, data: body);
      return {
        'isSuccess': true,
        'data': response.data,
      };
    } on DioError catch (e) {
      return {
        'isSuccess': false,
        'data': ApiError.fromDioError(e),
      };
    }
  }

  Future<List<Filter>> getAllRestaurantCategories() async {
    final response = await _makeRequest(url: ApiUrls.categories);

    if (response["isSuccess"]) {
      List<Filter> filters = [];
      for (final filter in response["data"]["categories"]) {
        filters.add(Filter.fromJson(filter));
      }
      return filters;
    } else {
      return null;
    }
  }

  Future<dynamic> getFilteredRestaurants({
    List<int> selectedFilters,
    String longitude,
    String latitude,
  }) async {
    Map<String, dynamic> body = {
      "category_ids": selectedFilters,
      "latitude": latitude,
      "longitude": longitude,
    };
    final response =
        await _makeRequest(url: ApiUrls.filteredRestaurants, body: body);
    return response['data'];
  }

  Future<dynamic> getRestaurantsAndItemsByQuery({
    String query,
    String longitude,
    String latitude,
  }) async {
    Map<String, dynamic> body = {
      "q": query,
      "latitude": latitude,
      "longitude": longitude,
    };
    final response = await _makeRequestToPersistentConnection(
        url: ApiUrls.searchRestaurants, body: body);
    if (response["isSuccess"]) {
      List<QueryItem> queryItems = [];

      for (final Map<String, dynamic> query in response['data']['items']) {
        queryItems.add(QueryItem.fromJson(query));
      }

      List<MinimalRestaurantData> queryRestaurants = [];

      for (final Map<String, dynamic> query in response['data']
          ['restaurants']) {
        queryRestaurants.add(MinimalRestaurantData.fromJson(
            query, {'latitude': latitude, 'longitude': longitude}));
      }

      queryRestaurants.sort((a, b) => b.isActive.compareTo(a.isActive));
      queryItems.sort((a, b) {
        int _a = a.isActive ? 1 : 0;
        int _b = b.isActive ? 1 : 0;
        return _b.compareTo(_a);
      });

      return {
        'restaurants': queryRestaurants,
        'items': queryItems,
      };
    }
    return response['data'];
  }

  Future<dynamic> getSingleItemById(int id) async {
    final response =
        await _makeRequest(url: ApiUrls.singleItemById, body: {'id': id});
    return response['data'];
  }

  Future<dynamic> walletTransactions() async {
    final idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;

    Map<String, dynamic> body = {
      "token": idAndToken["token"],
      "user_id": idAndToken["id"],
    };

    final response =
        await _makeRequest(url: ApiUrls.walletTransactions, body: body);

    if (response['data']['success']) {
      return Wallet.fromJson(response['data']);
    }
    return response['data'];
  }

  Future<dynamic> promoSlider() async {
    final response = await _makeRequest(url: ApiUrls.promoSlider);

    if (response['isSuccess']) {
      List<PromoSlide> slides = [];
      for (final Map<String, dynamic> slide in response['data']['mainSlides']) {
        slides.add(PromoSlide.fromJson(slide));
      }
      return slides;
    }
    return response['data'];
  }

  void saveNotificationToken(String token) async {
    final idAndToken = await _getIdAndToken();
    if (idAndToken == null) return;
    if (int.tryParse(idAndToken['id']) < 1) return;

    Map<String, dynamic> body = {
      "token": idAndToken["token"],
      "user_id": idAndToken["id"],
      "push_token": token,
    };
    _makeRequest(url: ApiUrls.saveNotificationToken, body: body);
  }

  Future<dynamic> getOrderMessages(String uniqueOrderId) async {
    final idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;
    if (int.tryParse(idAndToken['id']) < 1) return null;

    Map<String, dynamic> body = {
      "token": idAndToken["token"],
      "uniqueId": uniqueOrderId,
    };

    final response =
        await _makeRequest(url: ApiUrls.getOrderMessages, body: body);

    if (response['isSuccess']) {
      List<OrderMessage> messages = [];
      for (final message in response['data']['messages']) {
        messages.add(OrderMessage.fromJson(message));
      }
      return messages;
    }
    return response['data'];
  }

  Future<dynamic> sendMessage(String message, String uniqueId) async {
    final idAndToken = await _getIdAndToken();
    if (idAndToken == null) return null;
    if (int.tryParse(idAndToken['id']) < 1) return null;

    Map<String, dynamic> body = {
      'token': idAndToken["token"],
      'message': message,
      'uniqueId': uniqueId,
      'isUser': true,
    };

    final response = await _makeRequest(url: ApiUrls.sendMessage, body: body);

    if (response['isSuccess']) {
      return true;
    }
    return response['data'];
  }
}
