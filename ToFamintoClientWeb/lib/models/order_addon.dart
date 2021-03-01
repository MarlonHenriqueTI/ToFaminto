class OrderAddon {
  final int id;
  final String name;
  final String price;

  const OrderAddon({this.id, this.name, this.price});

  factory OrderAddon.fromJson(Map<String, dynamic> json) {
    return OrderAddon(
      id: json['id'],
      name: json['addon_category_name'],
      price: json['addon_price'],
    );
  }

  factory OrderAddon.fromJsonLite(Map<String, dynamic> json) {
    return OrderAddon(
      id: null,
      name: json['name'],
      price: json['price'],
    );
  }
}
