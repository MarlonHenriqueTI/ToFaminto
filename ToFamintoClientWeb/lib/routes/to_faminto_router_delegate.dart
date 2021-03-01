import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/enums.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/restaurants_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/cartScreen/cart_screen.dart';
import 'package:to_faminto_client/screens/checkoutScreen/checkout_screen.dart';
import 'package:to_faminto_client/screens/definitionsScreen/addressesScreen/sections/addresses/addresses_screen.dart';
import 'package:to_faminto_client/screens/definitionsScreen/addressesScreen/sections/newAddress/new_address.dart';
import 'package:to_faminto_client/screens/definitionsScreen/cardsScreen/cards_screen.dart';
import 'package:to_faminto_client/screens/definitionsScreen/cardsScreen/newCardScreen/new_card_screen.dart';
import 'package:to_faminto_client/screens/definitionsScreen/definitions_screen.dart';
import 'package:to_faminto_client/screens/definitionsScreen/profileScreen/profile_screen.dart';
import 'package:to_faminto_client/screens/definitionsScreen/walletScreen/wallet_screen.dart';
import 'package:to_faminto_client/screens/filterScreen/filter_screen.dart';
import 'package:to_faminto_client/screens/global_screen.dart';
import 'package:to_faminto_client/screens/homeScreen/home_screen.dart';
import 'package:to_faminto_client/screens/itemPersonalizationScreen/item_personalization_screen.dart';
import 'package:to_faminto_client/screens/loginRegisterScreen/login_register_screen.dart';
import 'package:to_faminto_client/screens/ordersScreen/ordersScreen.dart';
import 'package:to_faminto_client/screens/restaurantDetailsScreen/restaurant_details_screen.dart';

import 'routes.dart';

class ToFamintoRouterDelegate extends RouterDelegate<ToFamintoRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ToFamintoRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  RoutesState routesState = RoutesState();
  CartState cartState = CartState();
  CheckoutState checkoutState = CheckoutState();
  UserState userState = UserState();
  RestaurantsState restaurantsState = RestaurantsState();

  ToFamintoRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    routesState.addListener(notifyListeners);
  }

  ToFamintoRoutePath get currentConfiguration {
    if (routesState.currentRoute == NavigationRoute.HOME) {
      return HomePath();
    } else if (routesState.currentRoute == NavigationRoute.LOGIN_REGISTER) {
      return LoginRegisterPath();
    } else if (routesState.currentRoute == NavigationRoute.RESTAURANT) {
      return RestaurantPath(routesState.selectedRestaurantSlug);
    } else if (routesState.currentRoute == NavigationRoute.ITEM) {
      return ItemPath(
        slug: routesState.selectedRestaurantSlug,
        id: routesState.selectedRestaurantItem.id,
      );
    } else if (routesState.currentRoute == NavigationRoute.CHECKOUT) {
      return CheckoutPath();
    } else if (routesState.currentRoute == NavigationRoute.CHECKOUT_NEW_CARD) {
      return CheckoutNewCardPath();
    } else if (routesState.currentRoute == NavigationRoute.ORDERS) {
      return OrdersPath();
    } else if (routesState.currentRoute == NavigationRoute.CART) {
      return CartPath();
    } else if (routesState.currentRoute == NavigationRoute.DEFINITIONS) {
      return DefinitionsPath();
    } else if (routesState.currentRoute == NavigationRoute.PROFILE) {
      return ProfilePath();
    } else if (routesState.currentRoute == NavigationRoute.ADDRESSES) {
      return AddressesPath();
    } else if (routesState.currentRoute == NavigationRoute.CARDS) {
      return CardsPath();
    } else if (routesState.currentRoute == NavigationRoute.NEW_ADDRESS) {
      return NewAddressesPath();
    } else if (routesState.currentRoute == NavigationRoute.NEW_CARD) {
      return NewCardPath();
    } else if (routesState.currentRoute == NavigationRoute.FILTER) {
      return FilterPath();
    } else if (routesState.currentRoute == NavigationRoute.WALLET) {
      return WalletPath();
    }
    return LoginRegisterPath();
  }

  @override
  Future<void> setNewRoutePath(ToFamintoRoutePath path) async {
    if (path is HomePath) {
      routesState.currentRoute = NavigationRoute.HOME;
    } else if (path is LoginRegisterPath) {
      routesState.currentRoute = NavigationRoute.LOGIN_REGISTER;
    } else if (path is RestaurantPath) {
      routesState.currentRoute = NavigationRoute.RESTAURANT;
    } else if (path is ItemPath) {
      routesState.currentRoute = NavigationRoute.ITEM;
    } else if (path is CheckoutPath) {
      routesState.currentRoute = NavigationRoute.CHECKOUT;
    } else if (path is CheckoutNewCardPath) {
      routesState.currentRoute = NavigationRoute.CHECKOUT_NEW_CARD;
    } else if (path is OrdersPath) {
      routesState.currentRoute = NavigationRoute.ORDERS;
    } else if (path is CartPath) {
      routesState.currentRoute = NavigationRoute.CART;
    } else if (path is DefinitionsPath) {
      routesState.currentRoute = NavigationRoute.DEFINITIONS;
    } else if (path is ProfilePath) {
      routesState.currentRoute = NavigationRoute.PROFILE;
    } else if (path is AddressesPath) {
      routesState.currentRoute = NavigationRoute.ADDRESSES;
    } else if (path is CardsPath) {
      routesState.currentRoute = NavigationRoute.CARDS;
    } else if (path is NewAddressesPath) {
      routesState.currentRoute = NavigationRoute.NEW_ADDRESS;
    } else if (path is NewCardPath) {
      routesState.currentRoute = NavigationRoute.NEW_CARD;
    } else if (path is FilterPath) {
      routesState.currentRoute = NavigationRoute.FILTER;
    } else if (path is WalletPath) {
      routesState.currentRoute = NavigationRoute.WALLET;
    }
  }

  MaterialPage home() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          routesState: routesState,
          cartState: cartState,
          selectedScreenIndex: 0,
          restaurantsState: restaurantsState,
          userState: userState,
          checkoutState: checkoutState,
          screen: HomeScreen(
            routesState: routesState,
            restaurantsState: restaurantsState,
            userState: userState,
          ),
        ),
        key: ValueKey('HomeScreen'),
      ),
    );
  }

  MaterialPage restaurant() {
    return MaterialPage(
      key: ValueKey(routesState.selectedRestaurantSlug),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: restaurantsState,
          ),
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: checkoutState,
          ),
        ],
        child: RestaurantDetailsScreen(
          minimalRestaurantData: routesState.currentSelectedRestaurantMinData,
          slug: routesState.selectedRestaurantSlug,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          showCartButton: routesState.displayCartButton,
        ),
      ),
    );
  }

  MaterialPage item() {
    return MaterialPage(
      key: ValueKey(routesState.selectedRestaurantItem.name),
      child: ItemPersonalizationScreen(
        item: routesState.selectedRestaurantItem,
        uniqueItemCartId: routesState.uniqueItemCartId,
        cartState: cartState,
        routesState: routesState,
        checkoutState: checkoutState,
      ),
    );
  }

  MaterialPage cart() {
    cartState.removeAllDiscounts();
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 3,
          restaurantsState: restaurantsState,
          screen: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: userState,
              ),
              ChangeNotifierProvider.value(
                value: cartState,
              ),
            ],
            child: CartScreen(
              routesState: routesState,
              restaurantsState: restaurantsState,
              checkoutState: checkoutState,
            ),
          ),
        ),
      ),
    );
  }

  MaterialPage checkout() {
    return MaterialPage(
      child: CheckoutScreen(
        checkoutState: checkoutState,
        cartState: cartState,
        routesState: routesState,
        userState: userState,
      ),
    );
  }

  MaterialPage loginRegister() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          )
        ],
        child: LoginRegisterScreen(
          routesState: routesState,
        ),
      ),
    );
  }

  MaterialPage newCard({NavigationRoute returnTo}) {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: NewCardScreen(returnTo: returnTo),
      ),
    );
  }

  MaterialPage profile() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 4,
          restaurantsState: restaurantsState,
          screen: ChangeNotifierProvider.value(
            value: userState,
            child: ProfileScreen(),
          ),
        ),
      ),
    );
  }

  MaterialPage addresses() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 4,
          restaurantsState: restaurantsState,
          screen: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: userState,
              ),
              ChangeNotifierProvider.value(
                value: routesState,
              ),
              ChangeNotifierProvider.value(
                value: checkoutState,
              ),
              ChangeNotifierProvider.value(
                value: cartState,
              ),
            ],
            child: AddressesScreen(),
          ),
        ),
      ),
    );
  }

  MaterialPage cards() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 4,
          restaurantsState: restaurantsState,
          screen: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: routesState,
              ),
              ChangeNotifierProvider.value(
                value: userState,
              ),
            ],
            child: CardsScreen(),
          ),
        ),
      ),
    );
  }

  MaterialPage wallet() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 4,
          restaurantsState: restaurantsState,
          screen: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: routesState,
              ),
              ChangeNotifierProvider.value(
                value: userState,
              ),
            ],
            child: WalletScreen(),
          ),
        ),
      ),
    );
  }

  MaterialPage newAddress() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
          ChangeNotifierProvider.value(
            value: checkoutState,
          ),
          ChangeNotifierProvider.value(
            value: cartState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 4,
          restaurantsState: restaurantsState,
          screen: NewAddress(
            userState: userState,
            routesState: routesState,
          ),
        ),
      ),
    );
  }

  MaterialPage definitions() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 4,
          restaurantsState: restaurantsState,
          screen: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: routesState,
              ),
              ChangeNotifierProvider.value(
                value: userState,
              ),
              ChangeNotifierProvider.value(
                value: cartState,
              ),
              ChangeNotifierProvider.value(
                value: checkoutState,
              ),
            ],
            child: DefinitionsScreen(),
          ),
        ),
      ),
    );
  }

  MaterialPage orders() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 1,
          restaurantsState: restaurantsState,
          screen: OrdersScreen(),
        ),
      ),
    );
  }

  MaterialPage filter() {
    return MaterialPage(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: routesState,
          ),
          ChangeNotifierProvider.value(
            value: userState,
          ),
        ],
        child: GlobalScreen(
          userState: userState,
          routesState: routesState,
          cartState: cartState,
          checkoutState: checkoutState,
          selectedScreenIndex: 2,
          restaurantsState: restaurantsState,
          screen: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: userState,
              ),
              ChangeNotifierProvider.value(
                value: restaurantsState,
              ),
            ],
            child: FilterScreen(),
          ),
        ),
      ),
    );
  }

  List<Page> getPages() {
    if (routesState.currentRoute == NavigationRoute.HOME) {
      return [
        home(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.RESTAURANT) {
      return [
        home(),
        restaurant(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.ITEM) {
      return [
        home(),
        restaurant(),
        item(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.CART) {
      return [
        cart(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.CHECKOUT) {
      return [
        cart(),
        checkout(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.LOGIN_REGISTER ||
        routesState.currentRoute == null) {
      return [
        loginRegister(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.CHECKOUT_NEW_CARD) {
      if (routesState.returnRoute == NavigationRoute.CHECKOUT) {
        return [
          cart(),
          checkout(),
          newCard(returnTo: routesState.returnRoute),
        ];
      }
    } else if (routesState.currentRoute == NavigationRoute.PROFILE) {
      return [
        definitions(),
        profile(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.ADDRESSES) {
      return [
        definitions(),
        addresses(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.NEW_ADDRESS) {
      return [
        definitions(),
        addresses(),
        newAddress(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.CARDS) {
      return [
        definitions(),
        cards(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.NEW_CARD) {
      return [
        definitions(),
        cards(),
        newCard(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.DEFINITIONS) {
      return [
        definitions(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.ORDERS) {
      return [
        orders(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.FILTER) {
      return [
        filter(),
      ];
    } else if (routesState.currentRoute == NavigationRoute.WALLET) {
      return [
        definitions(),
        wallet(),
      ];
    }
    return [
      home(),
    ];
  }

  void onPop() {
    if (routesState.currentRoute == NavigationRoute.RESTAURANT) {
      routesState.selectedRestaurantSlug = null;
      restaurantsState.selectedRestaurantSlug = null;
      routesState.currentRoute = NavigationRoute.HOME;
    } else if (routesState.currentRoute == NavigationRoute.ITEM) {
      routesState.uniqueItemCartId = null;
      routesState.selectedRestaurantItem = null;
      routesState.displayCartButton = false;
      cartState.clearTemporaryItems();
      routesState.currentRoute = NavigationRoute.RESTAURANT;
    } else if (routesState.currentRoute == NavigationRoute.ORDERS) {
      routesState.currentRoute = NavigationRoute.ORDERS;
    } else if (routesState.currentRoute == NavigationRoute.CART) {
      restaurantsState.selectedRestaurantSlug = null;
      routesState.currentSelectedRestaurantMinData = null;
      routesState.selectedRestaurantSlug = null;
    } else if (routesState.currentRoute == NavigationRoute.CHECKOUT) {
      routesState.currentRoute = NavigationRoute.CART;
    } else if (routesState.currentRoute == NavigationRoute.CHECKOUT_NEW_CARD) {
      routesState.currentRoute = NavigationRoute.CHECKOUT;
    } else if (routesState.currentRoute == NavigationRoute.NEW_CARD) {
      routesState.currentRoute = NavigationRoute.CARDS;
    } else if (routesState.currentRoute == NavigationRoute.WALLET) {
      routesState.currentRoute = NavigationRoute.DEFINITIONS;
    } else if (routesState.currentRoute == NavigationRoute.NEW_ADDRESS) {
      routesState.currentRoute = NavigationRoute.ADDRESSES;
    } else if (routesState.currentRoute == NavigationRoute.PROFILE) {
      routesState.currentRoute = NavigationRoute.DEFINITIONS;
    } else if (routesState.currentRoute == NavigationRoute.WALLET) {
      routesState.currentRoute = NavigationRoute.DEFINITIONS;
    } else if (routesState.currentRoute == NavigationRoute.ADDRESSES) {
      routesState.currentRoute = NavigationRoute.DEFINITIONS;
    } else if (routesState.currentRoute == NavigationRoute.CARDS) {
      routesState.currentRoute = NavigationRoute.DEFINITIONS;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: getPages(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        onPop();
        notifyListeners();
        return true;
      },
    );
  }
}

class FadeAnimationPage extends Page {
  final Widget child;

  FadeAnimationPage({Key key, this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        final curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}
