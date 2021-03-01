import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/minimal_restaurant_data.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/utilities/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RestaurantInfo extends StatelessWidget {
  final MinimalRestaurantData restaurantData;
  final VoidCallback reloadWidget;
  RestaurantInfo({@required this.restaurantData, this.reloadWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConstants.mediumHorizontalPadding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: const Radius.circular(40),
          bottomRight: const Radius.circular(40),
        ),
        border: Border.all(color: AppStyle.lightGrey),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.motorcycle_outlined,
                      color: AppStyle.yellow,
                    ),
                    Text(
                      'R\$ ${restaurantData.deliveryCharge ?? 0.0}',
                      style: AppStyle.greyRegularText16Style(),
                    ),
                    Text(
                      '${restaurantData.deliveryTime ?? 60}min',
                      style: AppStyle.greyRegularText16Style(),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(restaurantData.imageUrl, scale: 100),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
              Container(
                width: 70.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (restaurantData.acceptsCardOnDelivery)
                      const Icon(
                        Icons.credit_card_outlined,
                        color: AppStyle.yellow,
                      ),
                    const Icon(
                      Icons.money_outlined,
                      color: AppStyle.yellow,
                    ),
                    if (restaurantData.acceptsOnlinePayment)
                      SizedBox(height: 4),
                    if (restaurantData.acceptsOnlinePayment)
                      SvgPicture.asset(
                        "assets/svgs/OnlinePayment.svg",
                        color: AppStyle.yellow,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConstants.verticalMediumSeparator),
          DeliveryTypeSelection(
            deliveryType: restaurantData.deliveryType,
            reloadWidget: reloadWidget,
          ),
          SizedBox(height: SizeConstants.verticalSmallSeparator),
          Text(
            restaurantData.description,
            style: AppStyle.mediumGreyRegularText14ItalicStyle(),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DeliveryTypeSelection extends StatefulWidget {
  final int deliveryType;
  final VoidCallback reloadWidget;

  const DeliveryTypeSelection({this.deliveryType, this.reloadWidget});
  @override
  _DeliveryTypeSelectionState createState() => _DeliveryTypeSelectionState();
}

class _DeliveryTypeSelectionState extends State<DeliveryTypeSelection> {
  int _selectedDeliveryType;

  void _assignSelectedDeliveryType(int deliveryType) {
    Provider.of<CheckoutState>(context, listen: false).deliveryType =
        deliveryType;
    _selectedDeliveryType = deliveryType;
    widget.reloadWidget();
  }

  @override
  void initState() {
    final _savedDeliveryType =
        Provider.of<CheckoutState>(context, listen: false).deliveryType;
    if (_savedDeliveryType != null) {
      _selectedDeliveryType = _savedDeliveryType;
    } else if (widget.deliveryType == 1) {
      Provider.of<CheckoutState>(context, listen: false).deliveryType = 1;
      _selectedDeliveryType = 1;
    } else if (widget.deliveryType == 2) {
      Provider.of<CheckoutState>(context, listen: false).deliveryType = 2;
      _selectedDeliveryType = 2;
    } else {
      Provider.of<CheckoutState>(context, listen: false).deliveryType = 1;
      _selectedDeliveryType = 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.deliveryType == 1 || widget.deliveryType == 3)
          DeliveryType(
            text: "Entrega",
            isSelected: _selectedDeliveryType == 1,
            onPressed: () => _assignSelectedDeliveryType(1),
          ),
        if (widget.deliveryType == 3) SizedBox(width: 5.0),
        if (widget.deliveryType == 2 || widget.deliveryType == 3)
          DeliveryType(
            text: "Retirada",
            isSelected: _selectedDeliveryType == 2,
            onPressed: () => _assignSelectedDeliveryType(2),
          ),
      ],
    );
  }
}

class DeliveryType extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onPressed;

  const DeliveryType({this.text, this.isSelected = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppStyle.yellow,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(color: AppStyle.yellow),
        ),
        child: Text(
          text,
          style: isSelected
              ? AppStyle.greyRegularText14Style()
              : AppStyle.whiteRegularText14Style(),
        ),
      ),
    );
  }
}
