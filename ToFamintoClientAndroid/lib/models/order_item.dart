import 'order_addon.dart';

class OrderItem {
  final int id;
  final String name;
  final String price;
  final int quantity;
  final List<OrderAddon> addons;

  const OrderItem({this.id, this.name, this.price, this.quantity, this.addons});

  factory OrderItem.fromOrderJson(Map<String, dynamic> json) {
    List<OrderAddon> _addons = [];
    for (Map<String, dynamic> addon
        in json['order_item_addons'] ?? json['addons']) {
      _addons.add(OrderAddon.fromJsonLite(addon));
    }

    return OrderItem(
      id: json['item_id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      addons: _addons,
    );
  }
}
