import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/addon.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/utilities/size_config.dart';

class AddonContainer extends StatefulWidget {
  final Addon addon;
  final int uniqueItemCartId;
  final int addonCategoryId;
  final bool isSingleOption;
  final bool isMultiOption;
  final Function setSelectedAddon;
  final Function removeSelectedAddon;
  final Function addSelectedAddon;
  final bool isSelected;
  final Function getSelectedAddonId;
  final int selectedAddonsAmount;
  final int maxAmount;
  const AddonContainer({
    Key key,
    this.addon,
    this.uniqueItemCartId,
    this.addonCategoryId,
    this.isSingleOption = false,
    this.setSelectedAddon,
    this.isSelected,
    this.getSelectedAddonId,
    this.isMultiOption = false,
    this.removeSelectedAddon,
    this.addSelectedAddon,
    this.selectedAddonsAmount,
    this.maxAmount,
  }) : super(key: key);

  @override
  _AddonContainerState createState() => _AddonContainerState();
}

class _AddonContainerState extends State<AddonContainer> {
  int amount;
  int uniqueId = -1;
  bool isSelected;
  int lastCheckedItemId = -1;

  void increaseAmount(context) {
    setState(() {
      final cartAddon = Provider.of<CartState>(context, listen: false).addAddon(
          widget.uniqueItemCartId,
          widget.addon,
          widget.addonCategoryId,
          widget.maxAmount);
      if (cartAddon != null && cartAddon != false) {
        uniqueId = cartAddon.uniqueCartId;
        amount = cartAddon.quantity;
      }
    });
  }

  void decreaseAmount(context) {
    setState(() {
      amount = Provider.of<CartState>(context, listen: false).removeAddon(
          widget.uniqueItemCartId, widget.addon, widget.addonCategoryId);
    });
  }

  void checkBox(BuildContext context) {
    if (widget.isSingleOption) {
      final bool clickedSameItem =
          Provider.of<CartState>(context, listen: false).swapItem(
              widget.uniqueItemCartId, widget.addon, widget.addonCategoryId);
      if (clickedSameItem)
        widget.removeSelectedAddon(null);
      else
        widget.setSelectedAddon(widget.addon.id);
    } else {
      bool canAdd = widget.selectedAddonsAmount < widget.maxAmount;
      final bool clickedSameItem =
          Provider.of<CartState>(context, listen: false).checkOne(
              widget.uniqueItemCartId,
              widget.addon,
              widget.addonCategoryId,
              canAdd);
      if (clickedSameItem)
        widget.removeSelectedAddon(widget.addon.id);
      else if (canAdd) widget.addSelectedAddon(widget.addon.id);
    }
  }

  @override
  void initState() {
    amount = Provider.of<CartState>(context, listen: false)
            .getAddonAmountByUniqueCartItemId(widget.addon,
                widget.uniqueItemCartId, widget.addonCategoryId) ??
        0;
    isSelected = widget.isSelected;
    if (isSelected == null) isSelected = amount > 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConstants.smallVerticalMargin),
      padding: EdgeInsets.fromLTRB(
        SizeConstants.generalHorizontalPadding,
        SizeConstants.generalHorizontalPadding,
        0,
        SizeConstants.generalHorizontalPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(9.0)),
        border: Border.all(
          color: AppStyle.lightGrey,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                Text(
                  widget.addon.name,
                  style: AppStyle.mediumGreyMediumTex14tStyle(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                Text(
                  '+R\$ ${widget.addon.price}',
                  style: AppStyle.greyMediumText14Style(),
                ),
              ],
            ),
          ),
          !widget.isSingleOption && !widget.isMultiOption
              ? Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () => decreaseAmount(context),
                        iconSize: SizeConstants.smallIconSize,
                        icon: const Icon(Icons.remove_outlined),
                      ),
                      Text(
                        amount.toString(),
                        style: AppStyle.mediumGreyMediumText16Style(),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () => increaseAmount(context),
                        iconSize: SizeConstants.smallIconSize,
                        icon: const Icon(Icons.add_outlined),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: SizeConstants.checkBoxSize,
                  width: SizeConstants.checkBoxSize,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConstants.generalHorizontalPadding),
                  decoration: BoxDecoration(
                    color: isSelected ? AppStyle.yellow : null,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: AppStyle.yellow),
                  ),
                  child: FlatButton(
                    onPressed: () => checkBox(context),
                    child: const SizedBox(),
                  ),
                ),
        ],
      ),
    );
  }
}
