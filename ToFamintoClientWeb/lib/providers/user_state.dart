import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/card.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/models/user.dart';
import 'package:to_faminto_client/models/wallet.dart';
import 'package:to_faminto_client/services/api_service.dart';
import 'package:to_faminto_client/services/notifications.dart';

class InformationContainer {
  final String title;
  final String content;

  InformationContainer(this.title, this.content);
}

abstract class UserStateAbstract extends ChangeNotifier {
  void saveNewAddress(UserAddress address);
  void saveUser(User user);
  void deleteUser();

  void saveNewCard(BankCard card);
  Future<dynamic> getSavedCards();
  void fetchCards();

  Future<User> getUser();
  Future<List<InformationContainer>> userDetailsList();
  void fetchAddresses();
  Future<dynamic> getSavedAddresses();
  Future<String> getUserName();
}

class UserState extends UserStateAbstract {
  ApiService _apiService = ApiService();
  bool _hasSavedToken = false;
  dynamic message;

  saveNotificationTokenToDatabase() async {
    if (!_hasSavedToken) {
      final _messaging = Messaging.instance;
      _hasSavedToken = true;

      final _prefs = await SharedPreferences.getInstance();
      final user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));

      if (user.notificationToken != null) {
        _messaging.init();
        final _token = await _messaging.getToken();
        if (_token != user.notificationToken) {
          _apiService.saveNotificationToken(_token);
          user.notificationToken = _token;
          _prefs.setString('currentUser', jsonEncode(user.toJson()));
        }
      } else if (user.notificationToken == null && !user.isGuess) {
        _messaging.init();
        _messaging.requestPermission().then((_) async {
          final _token = await _messaging.getToken();
          _apiService.saveNotificationToken(_token);
          user.notificationToken = _token;
          _prefs.setString('currentUser', jsonEncode(user.toJson()));
        });
      }
    }
  }

  @override
  Future<dynamic> saveNewAddress(UserAddress address) async {
    final coords = await _apiService.addressToCoords(address: address);

    if (coords is ApiError) {
      return coords;
    }

    UserAddress _completeAddress = address;
    _completeAddress.longitude = coords['lng'].toString();
    _completeAddress.latitude = coords['lat'].toString();

    final _prefs = await SharedPreferences.getInstance();
    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
    dynamic result;
    if (user.isGuess) {
      result = -1;
    } else {
      result = await _apiService.saveAddress(address: _completeAddress);
    }

    if (result != null) {
      _completeAddress.id = result;

      user.defaultAddressId = _completeAddress.id;

      if (user.addresses == null) {
        user.addresses = [_completeAddress];
      } else {
        user.addresses.add(_completeAddress);
      }

      _prefs.setString('currentUser', jsonEncode(user.toJson()));
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> setDefaultAddress(int id) async {
    final _prefs = await SharedPreferences.getInstance();
    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
    user.defaultAddressId = id;
    _prefs.setString('currentUser', jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<UserAddress> getDefaultAddress() async {
    final _prefs = await SharedPreferences.getInstance();

    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
    if (user.addresses == null || user.addresses.isEmpty) return null;

    return user.addresses.firstWhere(
        (element) => element.id == user.defaultAddressId, orElse: () {
      setDefaultAddress(user.addresses.first.id);
      return user.addresses.first;
    });
  }

  Future<int> getDefaultAddressId() async {
    final _prefs = await SharedPreferences.getInstance();
    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
    return user.defaultAddressId ?? null;
  }

  Future<Map<String, dynamic>> getDefaultAddressCoords() async {
    final _prefs = await SharedPreferences.getInstance();
    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));

    if (user.isGuess) {
      final authToken = _prefs.get('authToken');
      final id = _prefs.get('id');
      if (authToken != null && id != null) {
        user.isGuess = false;
        _prefs.setString('currentUser', jsonEncode(user.toJson()));
      }
    }

    if (user.addresses == null || user.addresses.isEmpty) {
      final future = await fetchAddresses();

      if (future == true) {
        user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
        if (user.addresses == null || user.addresses.isEmpty) return null;

        final defaultAddress = user.addresses.firstWhere(
            (address) => address.id == user.defaultAddressId ?? -1, orElse: () {
          setDefaultAddress(user.addresses.first.id);
          return user.addresses.first;
        });

        if (defaultAddress.cityName == "Erro") return null;

        if (defaultAddress == null) {
          return {
            'latitude': user.addresses.first.latitude,
            'longitude': user.addresses.first.longitude,
          };
        } else {
          return {
            'latitude': defaultAddress.latitude,
            'longitude': defaultAddress.longitude,
          };
        }
      } else {
        return null;
      }
    }

    final defaultAddress = user.addresses.firstWhere(
        (address) => address.id == user.defaultAddressId ?? -1, orElse: () {
      setDefaultAddress(user.addresses.first.id);
      return user.addresses.first;
    });

    if (defaultAddress.cityName == "Erro") return null;

    return {
      'latitude': defaultAddress.latitude,
      'longitude': defaultAddress.longitude,
    };
  }

  @override
  Future<dynamic> saveUser(User user) async {
    final _prefs = await SharedPreferences.getInstance();
    final encodedUser = _prefs.getString('currentUser');
    _prefs.setString('currentUser', jsonEncode(user.toJson()));

    if (encodedUser != null) {
      final User guest = User.fromPrefs(jsonDecode(encodedUser));
      final dynamic result = await saveNewAddress(guest.addresses.first);
      if (result is ApiError) {
        return result;
      }
      return true;
    }
    return false;
  }

  @override
  void deleteUser() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.remove('currentUser');
    _prefs.remove('authToken');
    _prefs.remove('id');
  }

  @override
  Future<User> getUser() async {
    final _prefs = await SharedPreferences.getInstance();
    return User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
  }

  @override
  Future<List<InformationContainer>> userDetailsList() async {
    User _user = await getUser();
    return [
      InformationContainer("Nome Completo", _user.name ?? ""),
      InformationContainer("E-mail", _user.email ?? ""),
      InformationContainer("Celular", _user.phone ?? ""),
      InformationContainer("Senha", "******"),
    ];
  }

  @override
  Future<dynamic> fetchAddresses() async {
    List<UserAddress> userAddresses = [];
    final response = await _apiService.getAddresses();

    if (response is ApiError) {
      return response;
    }

    if (response == null) return;

    for (final address in response) {
      userAddresses.add(UserAddress.fromJson(address));
    }

    final _prefs = await SharedPreferences.getInstance();
    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
    user.addresses = userAddresses;
    _prefs.setString('currentUser', jsonEncode(user.toJson()));
    return true;
  }

  @override
  Future<dynamic> getSavedAddresses({fetchNewData = false}) async {
    if (fetchNewData) {
      final response = await fetchAddresses();
      if (response is ApiError) {
        return response;
      }
    }
    final _prefs = await SharedPreferences.getInstance();
    final User user =
        User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));

    if (user.addresses == null || user.addresses.isEmpty) {
      return fetchNewData == true
          ? null
          : getSavedAddresses(fetchNewData: true);
    }

    return user.addresses;
  }

  void deleteAddress(UserAddress address) async {
    final result = await _apiService.deleteAddress(address: address);
    if (result == true) {
      fetchAddresses();
      notifyListeners();
    }
  }

  @override
  Future<String> getUserName() async {
    User user = await getUser();
    return user.name;
  }

  @override
  void saveNewCard(BankCard card) async {
    final _prefs = await SharedPreferences.getInstance();
    var _cards = _prefs.getStringList("cards");

    if (_cards == null) {
      _prefs.setStringList("cards", [card.toJson()]);
    } else {
      _cards.add(card.toJson());
      _prefs.setStringList("cards", _cards);
    }

    notifyListeners();
  }

  void deleteCard(int id) async {
    final result = await _apiService.deleteCard(id);
    if (result == true) {
      fetchCards();
      notifyListeners();
    }
  }

  @override
  Future<dynamic> fetchCards() async {
    List<BankCard> bankCards = [];
    final response = await _apiService.getCards();

    if (response is ApiError) {
      return response;
    }

    if (response == null) return;

    for (final card in response) {
      bankCards.add(BankCard.fromApiJson(card));
    }

    List<String> cardsToStore = [];
    for (final bankCard in bankCards) {
      cardsToStore.add(bankCard.toJson());
    }

    final _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList("cards", cardsToStore);
  }

  @override
  Future<dynamic> getSavedCards({bool fetchNewData = false}) async {
    if (fetchNewData) {
      final response = await fetchCards();
      if (response is ApiError) {
        return response;
      }
    }
    final _prefs = await SharedPreferences.getInstance();
    List<String> _cards = _prefs.getStringList("cards");

    if (_cards == null || _cards.isEmpty) {
      return fetchNewData == true ? null : getSavedCards(fetchNewData: true);
    }

    List<BankCard> _cardObjects = [];

    for (final _card in _cards) {
      _cardObjects.add(BankCard.fromJson(jsonDecode(_card)));
    }
    return _cardObjects;
  }

  void updateWallet(Wallet newWallet) async {
    final _prefs = await SharedPreferences.getInstance();
    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
    user.wallet = newWallet;
    _prefs.setString('currentUser', jsonEncode(user.toJson()));
  }

  void fetchWallet() async {
    final result = await _apiService.walletTransactions();
    if (result is ApiError)
      return;
    else
      updateWallet(result);
  }

  /// 0 value is coords
  ///
  /// 1 value is can show notification
  Future<List> getInitialData() async {
    final _prefs = await SharedPreferences.getInstance();
    final defaultCoords = getDefaultUserCoordinatesFromPrefs(_prefs);
    final canShowNotification = shouldShowNotificationToChangeApp(_prefs);

    return [defaultCoords, canShowNotification];
  }

  bool shouldShowNotificationToChangeApp(SharedPreferences _prefs) {
    return _prefs.containsKey('hasSeenNotificationToDownloadNewApp')
        ? true
        : false;
  }

  void setNewAppNotificationAsSeen() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('hasSeenNotificationToDownloadNewApp', true);
  }

  Future<Map<String, dynamic>> getDefaultUserCoordinatesFromPrefs(
      SharedPreferences _prefs) async {
    User user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
    if (user.isGuess) {
      final authToken = _prefs.get('authToken');
      final id = _prefs.get('id');
      if (authToken != null && id != null) {
        user.isGuess = false;
        _prefs.setString('currentUser', jsonEncode(user.toJson()));
      }
    }

    if (user.addresses == null || user.addresses.isEmpty) {
      final future = await fetchAddresses();

      if (future == true) {
        user = User.fromPrefs(jsonDecode(_prefs.getString('currentUser')));
        if (user.addresses == null || user.addresses.isEmpty) return null;

        final defaultAddress = user.addresses.firstWhere(
            (address) => address.id == user.defaultAddressId ?? -1, orElse: () {
          setDefaultAddress(user.addresses.first.id);
          return user.addresses.first;
        });

        if (defaultAddress.cityName == "Erro") return null;

        if (defaultAddress == null) {
          return {
            'latitude': user.addresses.first.latitude,
            'longitude': user.addresses.first.longitude,
          };
        } else {
          return {
            'latitude': defaultAddress.latitude,
            'longitude': defaultAddress.longitude,
          };
        }
      } else {
        return null;
      }
    }

    final defaultAddress = user.addresses.firstWhere(
        (address) => address.id == user.defaultAddressId ?? -1, orElse: () {
      setDefaultAddress(user.addresses.first.id);
      return user.addresses.first;
    });

    if (defaultAddress.cityName == "Erro") return null;

    return {
      'latitude': defaultAddress.latitude,
      'longitude': defaultAddress.longitude,
    };
  }
}
