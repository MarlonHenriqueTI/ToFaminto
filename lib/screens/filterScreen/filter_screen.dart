import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/api_urls.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/item.dart';
import 'package:to_faminto_client/models/minimal_restaurant_data.dart';
import 'package:to_faminto_client/models/query_item.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/restaurants_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';
import 'package:to_faminto_client/screens/homeScreen/sections/restaurantsListSection/components/restaurant.dart';
import 'package:to_faminto_client/services/api_service.dart';
import 'package:to_faminto_client/utilities/size_config.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _apiService = ApiService();
  final _controller = TextEditingController();
  List<QueryItem> _queryItems = <QueryItem>[];
  List<MinimalRestaurantData> _queryRestaurants = <MinimalRestaurantData>[];
  Map<String, dynamic> _userCoords;
  bool _fetchingData = false;
  Timer _userStoopedTyping;
  final _duration = Duration(milliseconds: 800);
  bool _changingToItemScreen = false;
  bool _wasDisposed = false;

  void searchQuery(BuildContext context) async {
    if (_userCoords != null && _controller.text.length > 0) {
      if (_userStoopedTyping != null) {
        _userStoopedTyping.cancel(); // clear timer
      }
      _userStoopedTyping = Timer(_duration, () => makeRequest());
    }
  }

  void makeRequest() async {
    if (!_wasDisposed) {
      setState(() {
        _fetchingData = true;
      });
    }

    final dynamic response = await _apiService.getRestaurantsAndItemsByQuery(
        query: _controller.text,
        latitude: _userCoords['latitude'],
        longitude: _userCoords['longitude']);
    if (response is ApiError) {
      return;
    } else {
      if (!_wasDisposed) {
        setState(() {
          _fetchingData = false;
          _queryItems = response['items'];
          _queryRestaurants = response['restaurants'];
        });
      }
    }
  }

  void setCoords(BuildContext context) async {
    _userCoords = await Provider.of<UserState>(context, listen: false)
        .getDefaultAddressCoords();
  }

  void showLoadingScreen() {
    setState(() {
      _changingToItemScreen = true;
    });
  }

  @override
  void initState() {
    setCoords(context);
    _apiService.openConnection(ApiUrls.searchRestaurants);
    _controller.addListener(() => searchQuery(context));
    super.initState();
  }

  @override
  void dispose() {
    _wasDisposed = true;
    _apiService.closeConnection();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_fetchingData || _changingToItemScreen)
              LinearProgressIndicator(backgroundColor: Colors.redAccent),
            TopNotch(
              "Explorar",
              margin: EdgeInsets.only(bottom: 10),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: _queryRestaurants.length + _queryItems.length,
                      itemBuilder: (context, index) {
                        final int restaurantsLength = _queryRestaurants.length;
                        if (_queryRestaurants.isNotEmpty && index == 0)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Lojas",
                                  style: AppStyle.mediumGreyMediumText18Style(),
                                ),
                              ),
                              SizedBox(height: 10),
                              RestaurantNew(_queryRestaurants[index]),
                            ],
                          );
                        if (index < restaurantsLength) {
                          return RestaurantNew(_queryRestaurants[index]);
                        } else if (index == restaurantsLength) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Itens",
                                  style: AppStyle.mediumGreyMediumText18Style(),
                                ),
                              ),
                              SizedBox(height: 10),
                              QueryItemWidget(
                                showLoadingScreen: showLoadingScreen,
                                item: _queryItems[index - (restaurantsLength)],
                              ),
                            ],
                          );
                        } else {
                          return QueryItemWidget(
                            showLoadingScreen: showLoadingScreen,
                            item: _queryItems[index - (restaurantsLength)],
                          );
                        }
                      },
                    ),
                  ),
                  SearchBar(controller: _controller),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QueryItemWidget extends StatelessWidget {
  final _apiService = ApiService();
  final QueryItem item;
  final VoidCallback showLoadingScreen;
  QueryItemWidget({@required this.item, @required this.showLoadingScreen});

  Future<bool> askIfWantsToLooseCartItems(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          "Ao adicionar um item de outra loja você perderá seus itens atuais.",
          style: AppStyle.mediumGreyMediumText16Style(),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Voltar",
              style: AppStyle.mediumGreyMediumTex14tStyle(),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Confirmar",
              style: AppStyle.mediumGreyMediumTex14tStyle(),
            ),
          ),
        ],
        elevation: 1.0,
      ),
    );
  }

  void changeToItemsScreen(BuildContext context, int uniqueCartId, Item item,
      MinimalRestaurantData minData) {
    Provider.of<RoutesState>(context, listen: false)
        .currentSelectedRestaurantMinData = minData;
    Provider.of<RoutesState>(context, listen: false).selectedRestaurantSlug =
        minData.slug;
    Provider.of<RoutesState>(context, listen: false)
        .changeToItemScreen(item, uniqueCartId);
  }

  /// returns -1 if the item being added belongs to a different store from
  /// the items currently on the cart
  int addNewItem(BuildContext context, Item item, double storeTax) {
    return Provider.of<CartState>(context, listen: false)
        .addNewItem(item, storeTax);
  }

  void deleteAllCartItems(BuildContext context) {
    Provider.of<CartState>(context, listen: false).clearCart();
  }

  void addToCart(BuildContext context) async {
    if (!item.isActive) {
      //showRestaurantIsClosedSnackbar();
      return;
    }

    final MinimalRestaurantData minResData =
        Provider.of<RestaurantsState>(context, listen: false)
            .getRestaurantMinDataById(item.restaurantId);

    if (minResData != null) {
      showLoadingScreen();
      final response = await _apiService.getSingleItemById(item.id);
      if (response is ApiError) {
        return;
      } else {
        final Item item = Item.fromMap(response, minResData.slug);

        final uniqueCartId =
            addNewItem(context, item, minResData.deliveryData.restaurantCharge);
        if (uniqueCartId == -1) {
          final canProceed = await askIfWantsToLooseCartItems(context);
          if (canProceed) {
            deleteAllCartItems(context);
            changeToItemsScreen(
                context,
                addNewItem(
                    context, item, minResData.deliveryData.restaurantCharge),
                item,
                minResData);
          }
        } else {
          changeToItemsScreen(context, uniqueCartId, item, minResData);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.isActive ? 1 : 0.7,
      child: InkWell(
        onTap: () {
          addToCart(context);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(9.0)),
            border: Border.all(
              color: AppStyle.lightGrey,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 55.0,
                width: 55.0,
                margin: const EdgeInsets.only(
                    right: SizeConstants.smallHorizontalMargin),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.image, scale: 100),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            item.name,
                            style: AppStyle.greyRegularText16Style(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "R\$ ${item.price.toStringAsFixed(2)}",
                          style: AppStyle.greyRegularText16Style(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.restaurantName,
                      style: AppStyle.mediumGreyMediumTex14tStyle(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: 40,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TextField(
        controller: controller,
        style: AppStyle.greyRegularText16Style(),
        cursorColor: AppStyle.yellow,
        textAlign: TextAlign.center,
        cursorHeight: 3,
        decoration: InputDecoration(
          hintText: "Digite uma Loja ou Item",
          hintStyle: AppStyle.greyRegularText16Style(),
          contentPadding: EdgeInsets.all(0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: AppStyle.yellow,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: AppStyle.yellow,
            ),
          ),
        ),
      ),
    );
  }
}
