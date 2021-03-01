import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/providers/restaurants_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'sections/restaurantsListSection/restaurants_list_section.dart';

class HomeScreen extends StatelessWidget {
  final RoutesState routesState;
  final RestaurantsState restaurantsState;
  final UserState userState;

  HomeScreen(
      {@required this.routesState,
      @required this.restaurantsState,
      @required this.userState});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: restaurantsState),
        ChangeNotifierProvider.value(value: routesState),
        ChangeNotifierProvider.value(value: userState),
      ],
      child: RestaurantsListSection(),
    );
  }
}
