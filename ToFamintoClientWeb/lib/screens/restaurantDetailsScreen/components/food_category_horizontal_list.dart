import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class FoodCategoriesHorizontalList extends StatefulWidget {
  final int currentIndex;
  final List items;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  const FoodCategoriesHorizontalList(
      {@required this.items,
      @required this.onPressed,
      this.padding,
      this.currentIndex});

  @override
  _FoodCategoriesHorizontalListState createState() =>
      _FoodCategoriesHorizontalListState();
}

class _FoodCategoriesHorizontalListState
    extends State<FoodCategoriesHorizontalList> {
  int currentIndex = 0;
  final double margin = 0.0;
  int buildCount = 0;

  ScrollController _scrollController;

  List<Map<String, dynamic>> _itemsInfo = [];

  List<GlobalKey> _keys = [];

  void onCategoryButtonPressed(int i) {
    alignItemToCenterScreen(i);
    widget.onPressed(i);
  }

  void alignItemToCenterScreen(int i) {
    setState(() {
      currentIndex = i;
      final double offset = _itemsInfo[i]['offset'];
      final double width = _itemsInfo[i]['width'];
      final double halfTheScreenSize = MediaQuery.of(context).size.width / 2;

      final result = ((offset + (width / 2)) - halfTheScreenSize) + margin;

      _scrollController.animateTo(result,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  List<Widget> buildCategoriesList() {
    List<Widget> buttons = [];
    _keys = [];
    if (widget.items.isNotEmpty) {
      buttons.add(SizedBox(
        width: margin,
      ));
      for (int i = 0; i < widget.items.length; i++) {
        _keys.add(GlobalKey());
        buttons.add(TextButton(
          key: _keys[i],
          child: Text(
            widget.items[i].name,
            style: currentIndex == i
                ? AppStyle.mediumGreyMediumTex14tStyle()
                : AppStyle.mediumOpacityGreyMediumText14Style(),
          ),
          onPressed: () => onCategoryButtonPressed(i),
        ));
      }
      buttons.add(SizedBox(
        width: margin,
      ));
    }
    return buttons;
  }

  void savePositions() {
    setState(() {
      for (var key in _keys) {
        RenderBox box = key.currentContext.findRenderObject();
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        _itemsInfo.add({'offset': position.dx, 'width': box.size.width});
      }
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController(
      initialScrollOffset: margin,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => savePositions());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildCount++;
    if (widget.currentIndex != null && buildCount > 2) {
      alignItemToCenterScreen(widget.currentIndex);
    }
    return Padding(
      padding: widget.padding ?? const EdgeInsets.fromLTRB(9.0, 0.0, 0.0, 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: buildCategoriesList(),
        ),
      ),
    );
  }
}
