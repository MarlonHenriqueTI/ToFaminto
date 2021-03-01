import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/filter.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/restaurants_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/custom_bottom_navigation_bar.dart';

import 'homeScreen/components/custom_chip.dart';

class GlobalScreen extends StatefulWidget {
  final RoutesState routesState;
  final CartState cartState;
  final RestaurantsState restaurantsState;
  final UserState userState;
  final CheckoutState checkoutState;
  final int selectedScreenIndex;
  final Widget screen;

  const GlobalScreen({
    @required this.routesState,
    @required this.cartState,
    @required this.selectedScreenIndex,
    @required this.restaurantsState,
    @required this.userState,
    @required this.checkoutState,
    @required this.screen,
  });

  @override
  _GlobalScreenState createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  Widget _currentScreen;
  int _currentScreenIndex = 0;

  Future<bool> onChanged(BuildContext context, int index) async {
    if (index == 0) {
      Provider.of<RoutesState>(context, listen: false)
          .changeToHomeScreen(shouldResetState: false);
      return true;
    } else if (index == 1) {
      final user =
          await Provider.of<UserState>(context, listen: false).getUser();
      if (user?.isGuess ?? true) {
        final bool response = await askToLoginRegister(context);
        if (response) {
          Provider.of<RoutesState>(context, listen: false)
              .changeToLoginRegisterScreen();
        } else {
          return false;
        }
      } else {
        Provider.of<RoutesState>(context, listen: false).changeToOrdersScreen();
        return true;
      }
    } else if (index == 2) {
      Provider.of<RoutesState>(context, listen: false).changeToFilterScreen();
      return true;
    } else if (index == 3) {
      Provider.of<RoutesState>(context, listen: false).changeToCartScreen();
      return true;
    } else if (index == 4) {
      final user =
          await Provider.of<UserState>(context, listen: false).getUser();
      if (user?.isGuess ?? true) {
        final bool response = await askToLoginRegister(context);
        if (response) {
          Provider.of<RoutesState>(context, listen: false)
              .changeToLoginRegisterScreen();
        } else {
          return false;
        }
      } else {
        Provider.of<RoutesState>(context, listen: false)
            .changeToDefinitionsScreen();
        return true;
      }
    }
    setState(() {});
  }

  Future<bool> askToLoginRegister(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          "Para continuar faça login ou cadastre-se",
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

  @override
  void didUpdateWidget(covariant GlobalScreen oldWidget) {
    _currentScreenIndex = widget.selectedScreenIndex;
    _currentScreen = widget.screen;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _currentScreenIndex = widget.selectedScreenIndex;
    _currentScreen = widget.screen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.cartState,
      child: Builder(
        builder: (_) => Scaffold(
          backgroundColor: AppStyle.whiteBackground,
          bottomNavigationBar: CustomBottomNavigationBar(
            initialIndex: _currentScreenIndex,
            showBorder: _currentScreenIndex != 0 && _currentScreenIndex != 2,
            onChanged: (index) => onChanged(context, index),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _currentScreen),
                if (_currentScreenIndex == 0)
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: widget.restaurantsState,
                      ),
                      ChangeNotifierProvider.value(
                        value: widget.userState,
                      ),
                    ],
                    child: FilterWidget(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<Filter> _allFilters = <Filter>[];
  bool _isFilterExpanded = false;
  bool _isSearchBarExpanded = false;
  final _searchQueryController = TextEditingController();
  UserAddress _address;

  void toggleSearchBarExpansion() {
    setState(() {
      _isSearchBarExpanded = !_isSearchBarExpanded;
    });
  }

  void toggleFilterExpansion() async {
    if (_allFilters.isEmpty) {
      _allFilters =
          await Provider.of<RestaurantsState>(context, listen: false).filters;
    }
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });
  }

  void applyFilters(BuildContext context) async {
    final Map<String, dynamic> coords =
        await Provider.of<UserState>(context, listen: false)
            .getDefaultAddressCoords();
    if (coords != null) {
      Provider.of<RestaurantsState>(context, listen: false)
          .applyRestaurantFilters(coords);
    }
  }

  Iterable<CustomChip> get filters sync* {
    for (final Filter filter in _allFilters) {
      yield CustomChip(
        text: filter.name,
        isSelected: Provider.of<RestaurantsState>(context, listen: false)
            .selectedFilters
            .contains(filter.id),
        onPressed: (bool value) {
          setState(
            () {
              if (value) {
                Provider.of<RestaurantsState>(context, listen: false)
                    .selectedFilters
                    .add(filter.id);
              } else {
                Provider.of<RestaurantsState>(context, listen: false)
                    .selectedFilters
                    .removeWhere((int id) => id == filter.id);
              }
            },
          );
        },
      );
    }
  }

  void setAddress() async {
    final address = await Provider.of<UserState>(context, listen: false)
        .getDefaultAddress();
    if (address != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _address = address;
        });
      });
    }
  }

  @override
  void initState() {
    setAddress();
    super.initState();
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_address == null) setAddress();
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppStyle.yellow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9),
          topRight: Radius.circular(9),
        ),
      ),
      child: Column(
        children: <Widget>[
          if (_isFilterExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: filters.toList(),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Text>[
                  if (_address?.type != null)
                    Text(
                      _address?.type,
                      style: AppStyle.whiteMediumText16Style(),
                    ),
                  Text(
                    _address?.streetName ?? "",
                    style: AppStyle.whiteMediumText16Style(),
                  ),
                ],
              ),
              Row(
                children: [
                  if (_isFilterExpanded)
                    SquareButton(
                      onPressed: () => applyFilters(context),
                      icon: Icon(
                        Icons.done_outlined,
                        color: AppStyle.yellow,
                      ),
                    ),
                  SquareButton(
                    onPressed: toggleFilterExpansion,
                    icon: Icon(
                      Icons.filter_list_outlined,
                      color: AppStyle.yellow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;

  const SquareButton({
    @required this.onPressed,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(9),
          ),
        ),
        child: icon,
      ),
    );
  }
}
