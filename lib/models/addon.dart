class Addon {
  int id;
  final String name;
  String price;
  int quantity = 0;
  final bool isDivisible;
  int divisions;

  Addon(this.id, this.name, this.price, this.isDivisible);

  factory Addon.fromMap(Map<String, dynamic> map, bool divisible) {
    return Addon(
      map['id'],
      map['name'],
      map['price'],
      divisible,
    );
  }
}
