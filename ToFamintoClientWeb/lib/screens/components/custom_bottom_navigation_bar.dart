import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final bool showBorder;
  final Function onChanged;
  final int initialIndex;

  const CustomBottomNavigationBar(
      {this.showBorder = false, @required this.onChanged, this.initialIndex});
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    final bool result = await widget.onChanged(index);
    if (result) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    _selectedIndex = widget.initialIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0,
      decoration: BoxDecoration(
        color: AppStyle.whiteBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        border: widget.showBorder
            ? Border.all(
                color: Colors.grey[200],
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppStyle.whiteBackground,
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  //Icons.store_mall_directory_outlined,
                  Icons.storefront_outlined,
                  color: AppStyle.yellow,
                ),
                label: "Lojas",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppStyle.yellow,
                ),
                label: "Pedidos",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_outlined,
                  color: AppStyle.yellow,
                ),
                label: "Explorar",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppStyle.yellow,
                ),
                label: "Carrinho",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                  color: AppStyle.yellow,
                ),
                label: "Definicoes",
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppStyle.yellow,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
