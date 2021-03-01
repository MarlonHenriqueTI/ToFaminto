import 'package:to_faminto_client/models/addon_category.dart';

class Item {
  final int id;
  final String restaurantSlug;
  final String image;
  final String name;
  final String price;
  final String description;
  final List<AddonCategory> addonCategories;

  const Item({
    this.id,
    this.restaurantSlug,
    this.image,
    this.name,
    this.price,
    this.description,
    this.addonCategories,
  });

  factory Item.fromMap(Map<String, dynamic> map, String slug) {
    List<AddonCategory> _addonCategories = [];
    for (Map<String, dynamic> addonCategory in map['addon_categories']) {
      _addonCategories.add(AddonCategory.fromMap(addonCategory));
    }

    return Item(
      id: map['id'],
      restaurantSlug: slug,
      image: "https://www.tofaminto.com${map['image']}",
      name: map['name'],
      price: map['price'],
      description: map['desc'].toString().trim(),
      addonCategories: _addonCategories,
    );
  }
}
