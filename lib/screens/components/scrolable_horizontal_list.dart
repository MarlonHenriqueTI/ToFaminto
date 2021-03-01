import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class ScrollableHorizontalList extends StatefulWidget {
  final List items;
  final Function onPressed;
  const ScrollableHorizontalList(
      {@required this.items, @required this.onPressed});

  @override
  _FoodCategoriesHorizontalListState createState() =>
      _FoodCategoriesHorizontalListState();
}

class _FoodCategoriesHorizontalListState
    extends State<ScrollableHorizontalList> {
  int currentIndex = 0;

  ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
  );

  List<double> _itemScrollOffsets = [];

  List<GlobalKey> _keys = [];

  void onPressed(int i) {
    setState(() {
      currentIndex = i;
      _scrollController.jumpTo(_itemScrollOffsets[i] / 2);
    });
    widget.onPressed(i);
  }

  List<TextButton> buildCategoriesList() {
    List<TextButton> buttons = [];
    if (widget.items.isNotEmpty) {
      for (int i = 0; i < widget.items.length; i++) {
        GlobalKey _key = GlobalKey();
        _keys.add(_key);
        buttons.add(TextButton(
          key: _keys[i],
          child: Text(
            widget.items[i].name,
            style: currentIndex == i
                ? AppStyle.mediumGreyMediumTex14tStyle()
                : AppStyle.mediumOpacityGreyMediumText14Style(),
          ),
          onPressed: () => onPressed(i),
        ));
      }
    }

    return buttons;
  }

  void savePositions() {
    setState(() {
      for (final key in _keys) {
        RenderBox box = key.currentContext.findRenderObject();
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        double x = position.dx;
        _itemScrollOffsets.add(x);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => savePositions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9.0, 10.0, 0.0, 10.0),
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
