import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/models/addon_category.dart';
import 'package:to_faminto_client/providers/cart_state.dart';

import 'addon_container.dart';

class AddonsList extends StatefulWidget {
  const AddonsList({
    this.currentAddonCategory,
    this.cartState,
    this.uniqueItemCartId,
    this.progressAddonCategory,
    @required this.removeSelectedAddon,
    @required this.addSelectedAddon,
    @required this.selectedAddonsIds,
  });

  final AddonCategory currentAddonCategory;
  final CartState cartState;
  final int uniqueItemCartId;
  final Function progressAddonCategory;
  final Function removeSelectedAddon;
  final Function addSelectedAddon;
  final List<int> selectedAddonsIds;

  @override
  _AddonsListState createState() => _AddonsListState();
}

class _AddonsListState extends State<AddonsList> {
  void setSelectedAddon(int uniqueId) {
    setState(() {
      widget.currentAddonCategory.selectedAddonId = uniqueId;
    });
    widget.progressAddonCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ChangeNotifierProvider.value(
            value: widget.cartState,
            child: ListView.builder(
              itemCount: widget.currentAddonCategory.addons.length,
              itemBuilder: (context, index) {
                if (widget.currentAddonCategory.type == 'SINGLE') {
                  return AddonContainer(
                    setSelectedAddon: (uniqueId) => setSelectedAddon(uniqueId),
                    isSelected:
                        widget.currentAddonCategory.selectedAddonId != null
                            ? widget.currentAddonCategory.selectedAddonId ==
                                widget.currentAddonCategory.addons[index].id
                            : null,
                    isSingleOption: true,
                    key: UniqueKey(),
                    addon: widget.currentAddonCategory.addons[index],
                    addonCategoryId: widget.currentAddonCategory.id,
                    uniqueItemCartId: widget.uniqueItemCartId,
                  );
                } else if (widget.currentAddonCategory.type == 'DIVISION') {
                  return AddonContainer(
                    removeSelectedAddon: (uniqueId) =>
                        widget.removeSelectedAddon(uniqueId),
                    addSelectedAddon: (uniqueId) =>
                        widget.addSelectedAddon(uniqueId),
                    maxAmount: widget.currentAddonCategory.divisions,
                    selectedAddonsAmount: widget.selectedAddonsIds?.length ?? 0,
                    isSelected: widget.selectedAddonsIds != null
                        ? widget.selectedAddonsIds
                            .where((element) =>
                                element ==
                                widget.currentAddonCategory.addons[index].id)
                            .isNotEmpty
                        : null,
                    isMultiOption: true,
                    key: UniqueKey(),
                    addon: widget.currentAddonCategory.addons[index],
                    addonCategoryId: widget.currentAddonCategory.id,
                    uniqueItemCartId: widget.uniqueItemCartId,
                  );
                } else {
                  return AddonContainer(
                    key: UniqueKey(),
                    addon: widget.currentAddonCategory.addons[index],
                    addonCategoryId: widget.currentAddonCategory.id,
                    maxAmount: widget.currentAddonCategory.maxAmount,
                    uniqueItemCartId: widget.uniqueItemCartId,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
