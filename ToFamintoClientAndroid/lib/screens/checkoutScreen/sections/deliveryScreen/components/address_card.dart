import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/user_address.dart';

class AddressCard extends StatelessWidget {
  final UserAddress clientAddress;
  final Function onTap;
  final int currentAddressId;
  final bool isSelected;

  const AddressCard(
      {@required this.clientAddress,
      @required this.onTap,
      @required this.currentAddressId,
      @required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context, clientAddress.id),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppStyle.yellowGradientStart,
                    AppStyle.yellowGradientEnd,
                  ],
                )
              : null,
          borderRadius: const BorderRadius.all(
            const Radius.circular(20.0),
          ),
          border: isSelected
              ? null
              : Border.all(
                  color: Colors.grey[200],
                  width: 1.0,
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            clientAddress.type != null
                ? Text(
                    "${clientAddress.type}",
                    style: isSelected
                        ? AppStyle.whiteRegularText14Style()
                        : AppStyle.greyRegularText14Style(),
                  )
                : SizedBox(),
            Text(
              "${clientAddress.streetName ?? ""}, ${clientAddress.doorNumber.toString() ?? ""}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: isSelected
                  ? AppStyle.whiteSemiBoldText16Style()
                  : AppStyle.greySemiBoldText16Style(),
            ),
            Text(
              "${clientAddress.neighborhoodName ?? ""}, ${clientAddress.cityName}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: isSelected
                  ? AppStyle.whiteRegularText14Style()
                  : AppStyle.greyRegularText14Style(),
            ),
            clientAddress.complement != null
                ? Text(
                    clientAddress.complement,
                    style: isSelected
                        ? AppStyle.whiteRegularText14Style()
                        : AppStyle.greyRegularText14Style(),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
