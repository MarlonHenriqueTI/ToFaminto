import 'item.dart';

class ItemCategory {
  final String name;
  List<Item> items = [];

  ItemCategory(this.name, items, String slug) {
    List<Item> unsortedItems = [];
    for (Map<String, dynamic> item in items) {
      unsortedItems.add(Item.fromMap(item, slug));
    }
    unsortedItems
        .sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
    this.items = unsortedItems;
  }
}
