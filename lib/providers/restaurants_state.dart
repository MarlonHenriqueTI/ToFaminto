import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/filter.dart';
import 'package:to_faminto_client/models/item_category.dart';
import 'package:to_faminto_client/models/promo_slider.dart';

import '../models/minimal_restaurant_data.dart';
import '../services/api_service.dart';
import 'helperMixins/filter_logic.dart';

class RestaurantsState extends ChangeNotifier with FilterLogic {
  final _apiService = ApiService();
  List<MinimalRestaurantData> _minimalRestaurantsDataOriginal = [];
  List<MinimalRestaurantData> _minimalRestaurantsData = [];
  List<ItemCategory> _categories = [];
  String _selectedRestaurantSlug;
  int selectedRestaurantId;
  DateTime lastRestaurantFetchTimestamp;
  DateTime lastRestaurantItemsFetchTimestamp;
  bool _hasPassedOneMinSinceLastRequest = true;
  bool _hasPassedFiveMinSinceLastItemsRequest = true;
  Map<String, dynamic> lastUsedCoordinates;
  List<Filter> _filters;
  List<int> selectedFilters = <int>[];
  bool isFetchingData = false;
  List<PromoSlide> sliders;

  UnmodifiableListView<MinimalRestaurantData> get minimalRestaurantData =>
      UnmodifiableListView(_minimalRestaurantsData);

  RestaurantsState() : _selectedRestaurantSlug = "";

  String get selectedRestaurantSlug => _selectedRestaurantSlug;

  set selectedRestaurantSlug(slug) {
    _selectedRestaurantSlug = slug;
  }

  List<ItemCategory> get categories => _categories;

  Future<List<Filter>> get filters async {
    final _prefs = await SharedPreferences.getInstance();
    final List<String> encodedFilters = _prefs.getStringList('filters');
    _filters = encodedFilters
        ?.map((encodedFilter) => Filter.fromJson(jsonDecode(encodedFilter)))
        ?.toList(growable: false);
    return _filters ?? [];
  }

  void fetchFilters() async {
    if (_filters != null) return;
    final response = await _apiService.getAllRestaurantCategories();
    if (response == null) return;
    if (_filters != response) {
      _filters = response;
    }
    final _prefs = await SharedPreferences.getInstance();

    List<String> encodedFilters = [];

    for (final Filter filter in _filters) {
      encodedFilters.add(filter.toJson());
    }

    _prefs.setStringList('filters', encodedFilters);
  }

  Future<dynamic> fetchRestaurantItems(String slug) async {
    if (_selectedRestaurantSlug == null || _selectedRestaurantSlug != slug) {
      if (lastRestaurantItemsFetchTimestamp != null &&
          _selectedRestaurantSlug != null) {
        _hasPassedFiveMinSinceLastItemsRequest = DateTime.now()
                .difference(lastRestaurantItemsFetchTimestamp)
                .inMinutes >=
            5;
      }

      if (_hasPassedFiveMinSinceLastItemsRequest ||
          _selectedRestaurantSlug == null ||
          _selectedRestaurantSlug != slug) {
        _categories = [];
        _selectedRestaurantSlug = slug;

        final itemsResponse = await _apiService.restaurantItems(slug);
        if (itemsResponse['isSuccess']) {
          lastRestaurantItemsFetchTimestamp = DateTime.now();
          itemsResponse['data']['items']
              .forEach((k, v) => _categories.add(ItemCategory(k, v, slug)));
          return true;
        } else {
          return itemsResponse['data'];
        }
      }
    }

    return false;
  }

  Future<dynamic> fetchMinimalRestaurantData(Map<String, dynamic> coordinates,
      {List<int> selectedFilters, bool isFilter = false}) async {
    if (sliders == null) {
      final result = await _apiService.promoSlider();
      if (result is ApiError) {
        isFetchingData = false;
        notifyListeners();
        return result;
      } else {
        sliders = result;
      }
    }

    if (lastRestaurantFetchTimestamp != null) {
      _hasPassedOneMinSinceLastRequest =
          DateTime.now().difference(lastRestaurantFetchTimestamp).inMinutes >=
              5;
    }

    bool isSameAddress;
    if (lastUsedCoordinates != null) {
      isSameAddress =
          (lastUsedCoordinates['longitude'] == coordinates['longitude'] &&
              lastUsedCoordinates['latitude'] == coordinates['latitude']);
    } else {
      isSameAddress = false;
    }

    if (_hasPassedOneMinSinceLastRequest || !isSameAddress || isFilter) {
      isFetchingData = true;
      notifyListeners();

      lastUsedCoordinates = coordinates;
      lastRestaurantFetchTimestamp = DateTime.now();

      final result = await _apiService.minimalRestaurantData(coordinates,
          selectedFilters: selectedFilters);

      if (result is ApiError) {
        isFetchingData = false;
        notifyListeners();
        return result;
      } else {
        _minimalRestaurantsDataOriginal = [];

        for (final restaurant in result) {
          _minimalRestaurantsDataOriginal
              .add(MinimalRestaurantData.fromJson(restaurant, coordinates));
        }

        _minimalRestaurantsData = List.from(_minimalRestaurantsDataOriginal);
        isFetchingData = false;
        notifyListeners();
        return null;
      }
    }
  }

  void applyRestaurantFilters(Map<String, dynamic> coords) {
    if (selectedFilters.isNotEmpty) {
      fetchMinimalRestaurantData(
        coords,
        selectedFilters: selectedFilters,
        isFilter: true,
      );
    } else {
      fetchMinimalRestaurantData(coords, isFilter: true);
    }

    isFetchingData = true;
    notifyListeners();
  }

  void toggleFilter(Filter filter) {
    super.toggleFilter(filter);
  }

  void clearAppliedFilters() {
    super.clearAppliedFilters();
    notifyListeners();
  }

  void clearAllFiltersAndReset(Map<String, dynamic> coords) {
    super.clearAppliedFilters();
    fetchMinimalRestaurantData(coords);
  }

  MinimalRestaurantData getRestaurantMinDataById(int resId) {
    if (_minimalRestaurantsData.isEmpty || _minimalRestaurantsData == null) {
      if (_minimalRestaurantsDataOriginal.isEmpty ||
          _minimalRestaurantsDataOriginal == null) {
        return null;
      } else {
        return _minimalRestaurantsDataOriginal
            .firstWhere((resData) => resData.id == resId, orElse: null);
      }
    } else {
      return _minimalRestaurantsData
          .firstWhere((resData) => resData.id == resId, orElse: null);
    }
  }
}
