import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/routes_state.dart';

import '../../../../../models/minimal_restaurant_data.dart';

class RestaurantNew extends StatelessWidget {
  final MinimalRestaurantData _minimalRestaurantData;

  const RestaurantNew(
    this._minimalRestaurantData,
  );

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _minimalRestaurantData.isActive == 0 ? 0.7 : 1,
      child: InkWell(
        onTap: () {
          Provider.of<RoutesState>(context, listen: false)
              .changeToRestaurantScreen(
                  minimalRestaurantData: _minimalRestaurantData);
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 114.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                border: Border.all(
                  color: AppStyle.lightGrey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _minimalRestaurantData.name,
                                    style: AppStyle
                                        .mediumGreySemiBoldText20Style(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    _minimalRestaurantData.description,
                                    style:
                                        AppStyle.darkGreyRegularText15Style(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.timer_sharp,
                                    size: 20.0,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    "${_minimalRestaurantData.deliveryTime}min",
                                    style: AppStyle.greyRegularText14Style(),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              SizedBox(width: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.motorcycle_sharp,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'R\$ ${_minimalRestaurantData.deliveryCharge}',
                                    style: AppStyle.greyRegularText14Style(),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              SizedBox(width: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.group_sharp,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'R\$ ${_minimalRestaurantData.priceRange}',
                                    style: AppStyle.greyRegularText14Style(),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 55.0,
                            width: 55.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    _minimalRestaurantData.imageUrl,
                                    scale: 100),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          _minimalRestaurantData.isActive == 0
                              ? Text(
                                  "Fechado",
                                  style: AppStyle.redMediumText14Style(),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 13.0),
          ],
        ),
      ),
    );
  }
}
