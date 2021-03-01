import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/screens/components/CardContainer.dart';

class CardsList extends StatefulWidget {
  final List<CardContainer> cards;

  CardsList({this.cards});

  @override
  _CardsListState createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  FixedExtentScrollController _controller;

  void onSelectedCardChanged(BuildContext context, int value) {
    Provider.of<CheckoutState>(context, listen: false)
        .assignCard(id: widget.cards[value].card.id, index: value);
  }

  @override
  void initState() {
    _controller = FixedExtentScrollController();
    final currentIndex =
        Provider.of<CheckoutState>(context, listen: false).selectedCardIndex;
    if (currentIndex != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _controller.jumpToItem(currentIndex));
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListWheelScrollView(
        children: widget.cards ?? [],
        controller: _controller,
        itemExtent: 232,
        diameterRatio: 2,
        perspective: 0.006,
        onSelectedItemChanged: (value) => onSelectedCardChanged(context, value),
        clipBehavior: Clip.none,
        physics: FixedExtentScrollPhysics(),
      ),
    );
  }
}
