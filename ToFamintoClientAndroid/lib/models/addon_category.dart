import 'addon.dart';

class AddonCategory {
  final int id;
  final int originalId;
  String name;
  final String type;
  final List<Addon> addons;
  final int divisions;
  int selectedAddonId;
  int maxAmount;

  AddonCategory(
      {this.originalId,
      this.id,
      this.name,
      this.type,
      this.addons,
      this.divisions,
      this.selectedAddonId,
      this.maxAmount});

  factory AddonCategory.fromMap(Map<String, dynamic> addonCategory) {
    bool divisible = addonCategory['divisions'] != null;
    List<Addon> _addons = [];
    for (Map<String, dynamic> addon in addonCategory['addons']) {
      _addons.add(Addon.fromMap(addon, divisible));
    }

    return AddonCategory(
      id: addonCategory['id'],
      name: addonCategory['name'],
      type: addonCategory['type'],
      addons: _addons,
      selectedAddonId: -1,
      divisions: addonCategory['divisions'],
      maxAmount: addonCategory['maxAmount'],
    );
  }

  factory AddonCategory.emptyFinalizeCategory() {
    return AddonCategory(
      id: -1,
      name: "Finalizar",
      type: "",
      addons: [],
      selectedAddonId: -1,
      divisions: null,
      maxAmount: 0,
    );
  }
}
