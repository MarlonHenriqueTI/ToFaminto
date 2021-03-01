import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/CardContainer.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<Dismissible> _cards = [];
  bool _hasLoaded = false;
  String _error;
  bool _hasDisposed = false;

  void changeToNewCardScreen(final BuildContext context) {
    Provider.of<RoutesState>(context, listen: false).changeToNewCardScreen();
  }

  void buildCardsList(final result) {
    _cards.add(
      Dismissible(
        key: Key(result[0].id.toString()),
        background: Container(
          padding: EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
        ),
        secondaryBackground: Container(
          padding: EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
        ),
        onDismissed: (direction) {
          Provider.of<UserState>(context, listen: false)
              .deleteCard(result[0].id);
          setState(() {
            _cards.removeAt(0);
          });
        },
        child: CardContainer(
          card: result[0],
          height: 126,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        ),
      ),
    );

    for (int i = 1; i < result.length; i++) {
      _cards.add(Dismissible(
        key: Key(result[i].id.toString()),
        background: Container(
          padding: EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
        ),
        secondaryBackground: Container(
          padding: EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
        ),
        onDismissed: (direction) {
          Provider.of<UserState>(context, listen: false)
              .deleteCard(result[i].id);
          setState(() {
            _cards.removeAt(i);
          });
        },
        child: CardContainer(
          card: result[i],
          height: 126,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        ),
      ));
    }
  }

  void getSavedCards(final BuildContext context) async {
    final result = await Provider.of<UserState>(context, listen: false)
        .getSavedCards(fetchNewData: true);
    if (_hasDisposed) return;
    if (result is ApiError) {
      setState(() {
        _error = result.text;
      });
    } else {
      if (result != null && result.isNotEmpty) {
        buildCardsList(result);
      }
      setState(() {
        _hasLoaded = true;
      });
    }
  }

  @override
  void initState() {
    getSavedCards(context);
    super.initState();
  }

  @override
  void dispose() {
    _hasDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TopNotch(
              "Cartões",
              applyMargin: true,
            ),
            _error == null
                ? _hasLoaded
                    ? _cards.isNotEmpty
                        ? Expanded(
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ..._cards ?? [],
                                      SizedBox(
                                        height: 70,
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  width: MediaQuery.of(context).size.width,
                                  child: BottomScreenLargeButton(
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Icon(
                                      Icons.add_outlined,
                                      color: AppStyle.yellow,
                                    ),
                                    onPressed: (ctx) =>
                                        changeToNewCardScreen(ctx),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : BottomScreenLargeButton(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Icon(
                              Icons.add_outlined,
                              color: AppStyle.yellow,
                            ),
                            onPressed: (ctx) => changeToNewCardScreen(ctx),
                            color: Colors.white,
                          )
                    : Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                : Expanded(
                    child: Center(
                      child: Text(_error),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
