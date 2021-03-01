import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_faminto_client/models/item.dart';
import 'package:to_faminto_client/models/minimal_restaurant_data.dart';
import '../constants/enums.dart';

class RoutesState extends ChangeNotifier {
  String selectedRestaurantSlug;
  Item selectedRestaurantItem;
  int _selectedDefinitionsIndex;
  int selectedRestaurantId;
  int uniqueItemCartId;
  NavigationRoute currentRoute;
  NavigationRoute returnRoute;
  MinimalRestaurantData currentSelectedRestaurantMinData;

  bool newAddressScreenCalledFromCheckout;
  bool displayCartButton;
  bool canRenderCart = true;

  int get selectedDefinitionsIndex => _selectedDefinitionsIndex;
  set selectedDefinitionsIndex(int idx) {
    _selectedDefinitionsIndex = idx;
    if (_selectedDefinitionsIndex == 1) {
      selectedRestaurantSlug = null;
    }
    notifyListeners();
  }

  RoutesState()
      : _selectedDefinitionsIndex = 0,
        displayCartButton = false;

  /// resetState does not reset the route
  void resetState() {
    selectedRestaurantSlug = null;
    selectedRestaurantItem = null;
    uniqueItemCartId = null;
    currentSelectedRestaurantMinData = null;
  }

  void changeToHomeScreen({bool shouldResetState}) {
    if (shouldResetState) {
      resetState();
    }
    currentRoute = NavigationRoute.HOME;
    notifyListeners();
  }

  void changeToRestaurantScreen(
      {MinimalRestaurantData minimalRestaurantData, showCartButton = false}) {
    if (minimalRestaurantData != null) {
      selectedRestaurantSlug = minimalRestaurantData.slug;
      currentSelectedRestaurantMinData = minimalRestaurantData;
    }
    displayCartButton = showCartButton;
    currentRoute = NavigationRoute.RESTAURANT;
    notifyListeners();
  }

  void changeToItemScreen(Item item, int id) {
    currentRoute = NavigationRoute.ITEM;
    selectedRestaurantItem = item;
    uniqueItemCartId = id;
    notifyListeners();
  }

  void changeToCartScreen() {
    currentRoute = NavigationRoute.CART;
    notifyListeners();
  }

  void changeToCheckoutScreen({int screenIndex = 0}) {
    currentRoute = NavigationRoute.CHECKOUT;
    notifyListeners();
  }

  void changeToNewAddressScreen({bool comesFromCheckout = false}) {
    currentRoute = NavigationRoute.NEW_ADDRESS;
    newAddressScreenCalledFromCheckout = comesFromCheckout;
    notifyListeners();
  }

  void changeToLoginRegisterScreen() {
    currentRoute = NavigationRoute.LOGIN_REGISTER;
    notifyListeners();
  }

  void changeToNewCardScreen() {
    currentRoute = NavigationRoute.NEW_CARD;
    notifyListeners();
  }

  void changeToNewCheckoutCardScreen({NavigationRoute returnTo}) {
    currentRoute = NavigationRoute.CHECKOUT_NEW_CARD;
    returnRoute = returnTo;
    notifyListeners();
  }

  void changeToOrdersScreen() {
    currentRoute = NavigationRoute.ORDERS;
    notifyListeners();
  }

  void changeToDefinitionsScreen() {
    currentRoute = NavigationRoute.DEFINITIONS;
    notifyListeners();
  }

  void changeToFilterScreen() {
    currentRoute = NavigationRoute.FILTER;
    notifyListeners();
  }

  Future<bool> isUserLoggedIn() async {
    final _prefs = await SharedPreferences.getInstance();

    final authToken = _prefs.get('authToken');
    final id = _prefs.get('id');

    if (authToken != null && id != null) {
      return true;
    } else {
      return false;
    }
  }

  void changeToProfileScreen() {
    currentRoute = NavigationRoute.PROFILE;
    notifyListeners();
  }

  void changeToAddressesScreen() {
    currentRoute = NavigationRoute.ADDRESSES;
    notifyListeners();
  }

  void changeToCardsScreen() {
    currentRoute = NavigationRoute.CARDS;
    notifyListeners();
  }

  void changeToWalletScreen() {
    currentRoute = NavigationRoute.WALLET;
    notifyListeners();
  }
}
