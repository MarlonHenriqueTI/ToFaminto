import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/minimal_restaurant_data.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/restaurants_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/utilities/size_config.dart';

import '../../models/item_category.dart';
import 'components/food_category_horizontal_list.dart';
import 'components/restaurant_info.dart';
import 'components/restaurant_item.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String slug;
  final RoutesState routesState;
  final CartState cartState;
  final CheckoutState checkoutState;
  final MinimalRestaurantData minimalRestaurantData;
  final bool showCartButton;

  const RestaurantDetailsScreen({
    this.slug,
    this.routesState,
    this.cartState,
    this.minimalRestaurantData,
    this.showCartButton,
    this.checkoutState,
  });

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  List<ItemCategory> _categories = [];
  ItemCategory _currentCategory;
  bool _loadedData = false;
  String _error;
  bool _hasBeenDisposed = false;

  void fetchRestaurantInfo() async {
    final response = await Provider.of<RestaurantsState>(context, listen: false)
        .fetchRestaurantItems(widget.slug);
    if (_hasBeenDisposed) return;

    if (response is ApiError) {
      if (_hasBeenDisposed) return;
      setState(() {
        _error = response.text;
      });
    } else {
      if (_hasBeenDisposed) return;
      setState(() {
        _categories =
            Provider.of<RestaurantsState>(context, listen: false).categories;
        _currentCategory = _categories.first;
        _loadedData = true;
      });
    }
  }

  void changeCategory(int index) {
    setState(() {
      _currentCategory = _categories[index];
    });
  }

  void changeToCartScreen(BuildContext context) {
    Provider.of<RoutesState>(context, listen: false).changeToCartScreen();
  }

  void showRestaurantIsClosedSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Loja fechada",
          style: AppStyle.whiteMediumText16Style(),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    _hasBeenDisposed = false;
    fetchRestaurantInfo();
    super.initState();
  }

  @override
  void dispose() {
    _hasBeenDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: widget.showCartButton
          ? FloatingActionButton(
              backgroundColor: AppStyle.yellow,
              elevation: 5,
              onPressed: () => changeToCartScreen(context),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
            )
          : null,
      body: SafeArea(
        child: _error == null
            ? _loadedData
                ? Column(
                    children: [
                      ChangeNotifierProvider.value(
                        value: widget.checkoutState,
                        child: RestaurantInfo(
                          restaurantData: widget.minimalRestaurantData,
                          reloadWidget: () => setState(() {}),
                        ),
                      ),
                      if (_categories.isNotEmpty)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConstants.generalHorizontalPadding),
                            child: ChangeNotifierProvider.value(
                              value: widget.cartState,
                              child: ListView.builder(
                                reverse: true,
                                itemCount: _currentCategory.items.length,
                                itemBuilder: (context, index) {
                                  return RestaurantItem(
                                    showSnackBar: () =>
                                        showRestaurantIsClosedSnackbar(context),
                                    restaurantIsClosed:
                                        widget.minimalRestaurantData.isActive ==
                                                0
                                            ? true
                                            : false,
                                    item: _currentCategory.items[index],
                                    storeTax: widget.minimalRestaurantData
                                        .deliveryData.restaurantCharge,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      FoodCategoriesHorizontalList(
                          items: _categories,
                          onPressed: (index) => changeCategory(index)),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
            : Center(
                child: Text(_error),
              ),
      ),
    );
  }
}
