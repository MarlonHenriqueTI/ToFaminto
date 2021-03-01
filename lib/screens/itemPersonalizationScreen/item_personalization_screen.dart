import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/addon_category.dart';
import 'package:to_faminto_client/models/item.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/screens/restaurantDetailsScreen/components/food_category_horizontal_list.dart';
import 'package:to_faminto_client/utilities/size_config.dart';

import 'components/addons_list.dart';
import '../components/bottom_screen_large_button.dart';
import 'components/final_item_container.dart';
import 'components/ingredients_container.dart';
import '../components/item_container.dart';
import '../components/top_notch.dart';

class ItemPersonalizationScreen extends StatefulWidget {
  final Item item;
  final RoutesState routesState;
  final CartState cartState;
  final CheckoutState checkoutState;

  final int uniqueItemCartId;
  const ItemPersonalizationScreen(
      {this.item,
      this.routesState,
      this.cartState,
      this.uniqueItemCartId,
      this.checkoutState});

  @override
  _ItemPersonalizationScreenState createState() =>
      _ItemPersonalizationScreenState();
}

class _ItemPersonalizationScreenState extends State<ItemPersonalizationScreen> {
  List<AddonCategory> _addonCategories = [];
  AddonCategory _currentAddonCategory;
  bool isFinalize = false;
  int currentIndex = 0;
  List<int> _selectedAddonsIds = [];

  void changeAddonCategory(int index) {
    setState(() {
      currentIndex = index;
      if (currentIndex < _addonCategories.length - 1) {
        isFinalize = false;
        _currentAddonCategory = _addonCategories[currentIndex];
      } else {
        isFinalize = true;
      }
    });
  }

  void progressAddonCategory() {
    setState(() {
      currentIndex++;
      if (currentIndex < _addonCategories.length - 1) {
        isFinalize = false;
        _currentAddonCategory = _addonCategories[currentIndex];
      } else {
        isFinalize = true;
      }
    });
  }

  void confirmItem(BuildContext context) {
    bool canChangeToRestaurantScreen =
        Provider.of<CartState>(context, listen: false)
            .setItemToPerm(widget.uniqueItemCartId);

    if (canChangeToRestaurantScreen) {
      Provider.of<CheckoutState>(context, listen: false).currentScreenIndex = 0;
      Provider.of<RoutesState>(context, listen: false)
          .changeToRestaurantScreen(showCartButton: true);
    }
  }

  void removeSelectedAddon(int uniqueId) {
    setState(() {
      _selectedAddonsIds.remove(uniqueId);
    });
  }

  void addSelectedAddon(int uniqueId) {
    setState(() {
      _selectedAddonsIds.add(uniqueId);
    });
  }

  @override
  void deactivate() {
    _selectedAddonsIds = [];
    _currentAddonCategory.selectedAddonId = null;
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    final allAddonCategories = widget.item.addonCategories;
    if (allAddonCategories.isEmpty) {
      isFinalize = true;
    } else {
      _addonCategories = allAddonCategories;
    }

    bool canAddFinalize = true;
    for (final category in allAddonCategories) {
      if (category.name == "Finalizar") {
        canAddFinalize = false;
      }
    }
    if (canAddFinalize) {
      _addonCategories.add(AddonCategory.emptyFinalizeCategory());
    }
    _currentAddonCategory = _addonCategories.first;
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      TopNotch(
                        "Personalização",
                        margin: EdgeInsets.only(
                            bottom: SizeConstants.verticalMediumSeparator),
                      ),
                      ItemContainer(item: widget.item),
                      widget.item.description == null ||
                              widget.item.description == ""
                          ? SizedBox()
                          : IngredientsContainer(item: widget.item),
                      SizedBox(height: SizeConstants.verticalMediumSeparator),
                      if (_currentAddonCategory.maxAmount != 0 && !isFinalize)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Máx: ${_currentAddonCategory.maxAmount}',
                            style: AppStyle.redMediumText14Style(),
                          ),
                        ),
                      if (_currentAddonCategory.maxAmount != 0 && !isFinalize)
                        SizedBox(height: SizeConstants.verticalMediumSeparator),
                      isFinalize
                          ? Expanded(
                              child: ChangeNotifierProvider.value(
                                value: widget.cartState,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <FinalItemContainer>[
                                    FinalItemContainer(
                                        uniqueItemCartId:
                                            widget.uniqueItemCartId),
                                  ],
                                ),
                              ),
                            )
                          : AddonsList(
                              progressAddonCategory: progressAddonCategory,
                              currentAddonCategory: _currentAddonCategory,
                              cartState: widget.cartState,
                              uniqueItemCartId: widget.uniqueItemCartId,
                              selectedAddonsIds: _selectedAddonsIds,
                              addSelectedAddon: (uniqueId) =>
                                  addSelectedAddon(uniqueId),
                              removeSelectedAddon: (uniqueId) =>
                                  removeSelectedAddon(uniqueId),
                            ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    if (isFinalize)
                      MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(
                            value: widget.cartState,
                          ),
                          ChangeNotifierProvider.value(
                            value: widget.routesState,
                          ),
                          ChangeNotifierProvider.value(
                            value: widget.checkoutState,
                          ),
                        ],
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: BottomScreenLargeButton(
                            margin: _addonCategories.length == 1
                                ? EdgeInsets.all(
                                    SizeConstants.generalHorizontalMargin)
                                : EdgeInsets.fromLTRB(
                                    SizeConstants.generalHorizontalMargin,
                                    SizeConstants.generalHorizontalMargin,
                                    SizeConstants.generalHorizontalMargin,
                                    0,
                                  ),
                            onPressed: (ctx) => confirmItem(ctx),
                            child: const Icon(
                              Icons.add_shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (_addonCategories.length != 1)
                      FoodCategoriesHorizontalList(
                        currentIndex: currentIndex,
                        onPressed: (index) => changeAddonCategory(index),
                        items: _addonCategories,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
