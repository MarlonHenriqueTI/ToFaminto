class QueryItem {
  final int id;
  final String name;
  final String image;
  final double price;
  final int restaurantId;
  final String restaurantName;
  final bool isActive;

  QueryItem(
    this.id,
    this.name,
    this.image,
    this.price,
    this.restaurantId,
    this.restaurantName,
    this.isActive,
  );

  factory QueryItem.fromJson(Map<String, dynamic> json) {
    return QueryItem(
      json["id"],
      json["name"],
      "https://www.tofaminto.com/${json['image']}",
      double.parse(json["price"]),
      json["restaurantId"],
      json["restaurantName"],
      json["isActive"] == 1,
    );
  }
}
