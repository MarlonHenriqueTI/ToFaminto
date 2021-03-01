import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/promo_slider.dart';
import 'package:to_faminto_client/providers/restaurants_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/utilities/size_config.dart';

import 'components/restaurant.dart';

class RestaurantsListSection extends StatefulWidget {
  @override
  _RestaurantsListSectionState createState() => _RestaurantsListSectionState();
}

class _RestaurantsListSectionState extends State<RestaurantsListSection> {
  String _error;
  bool _isFetchingData = false;
  bool _hasBeenDisposed = false;

  void initiateData(BuildContext context) async {
    _isFetchingData = true;
    Provider.of<RestaurantsState>(context, listen: false).fetchFilters();

    final defaultAddressCoords =
        await Provider.of<UserState>(context, listen: false)
            .getDefaultAddressCoords();

    if (defaultAddressCoords == null) {
      _hasBeenDisposed = true;
      Provider.of<RoutesState>(context, listen: false)
          .changeToNewAddressScreen();
    }

    if (_hasBeenDisposed) return;
    Provider.of<UserState>(context, listen: false)
        .saveNotificationTokenToDatabase();

    final response = await Provider.of<RestaurantsState>(context, listen: false)
        .fetchMinimalRestaurantData(defaultAddressCoords);
    if (response is ApiError) _error = response.text;

    if (_hasBeenDisposed) {
      return;
    } else {
      setState(() {
        _isFetchingData = false;
      });
    }
  }

  Iterable<PromoSlideWidget> buildSlider(List<PromoSlide> slides) sync* {
    for (final PromoSlide slide in slides) {
      yield PromoSlideWidget(slide: slide);
    }
  }

  @override
  void initState() {
    initiateData(context);
    super.initState();
  }

  @override
  void dispose() {
    _hasBeenDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _error != null
        ? Center(
            child: Text(_error),
          )
        : Container(
            margin: const EdgeInsets.only(
                bottom: SizeConstants.filterHeight, top: 10),
            child: Consumer<RestaurantsState>(
              builder: (context, restaurantsProvider, child) {
                if (_isFetchingData || restaurantsProvider.isFetchingData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (restaurantsProvider.minimalRestaurantData.isEmpty) {
                  return Center(
                    child: Text(
                      "Nenhuma loja encontrada :(",
                      style: AppStyle.greyRegularText16Style(),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount:
                        restaurantsProvider.minimalRestaurantData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: buildSlider(
                                            restaurantsProvider.sliders ?? [])
                                        .toList() ??
                                    [],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      } else {
                        return RestaurantNew(restaurantsProvider
                            .minimalRestaurantData[index - 1]);
                      }
                    },
                  );
                }
              },
            ),
          );
  }
}

class PromoSlideWidget extends StatelessWidget {
  final PromoSlide slide;

  const PromoSlideWidget({Key key, this.slide}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 130.0,
      width: 130.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9)),
        //border: Border.all(color: AppStyle.lightGrey),
        image: DecorationImage(
          image: NetworkImage(slide.image, scale: 100),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
