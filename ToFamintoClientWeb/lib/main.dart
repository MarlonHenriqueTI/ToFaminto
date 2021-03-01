import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_faminto_client/routes/to_faminto_route_information_parser.dart';
import 'package:to_faminto_client/routes/to_faminto_router_delegate.dart';
import 'package:to_faminto_client/services/notifications.dart';

import 'constants/app_style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(ToFamintoApp()));
}

class ToFamintoApp extends StatefulWidget {
  @override
  _ToFamintoAppState createState() => _ToFamintoAppState();
}

class _ToFamintoAppState extends State<ToFamintoApp> {
  ToFamintoRouterDelegate _routerDelegate = ToFamintoRouterDelegate();
  ToFamintoRouteInformationParser _routeInformationParser =
      ToFamintoRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: AppStyle.yellow,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        unselectedWidgetColor: Colors.white,
        splashColor: Colors.transparent,
      ),
      title: 'Tô Faminto',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
