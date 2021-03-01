import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/providers/user_state.dart';

class AddressCard extends StatelessWidget {
  final UserAddress clientAddress;
  final int defaultAddressId;
  final Function onTap;
  final Function remove;

  const AddressCard({
    @required this.clientAddress,
    @required this.onTap,
    @required this.defaultAddressId,
    @required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.red,
        ),
      ),
      secondaryBackground: Container(
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.red,
        ),
      ),
      key: Key(clientAddress.id.toString()),
      onDismissed: (direction) {
        Provider.of<UserState>(context, listen: false)
            .deleteAddress(clientAddress);
        remove(clientAddress.id);
      },
      child: InkWell(
        key: Key(clientAddress.id.toString()),
        onTap: () => onTap(context, clientAddress.id),
        //onTap: () => {print("fuck")},
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color:
                defaultAddressId == clientAddress.id ? AppStyle.yellow : null,
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
            border: Border.all(
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
                      style: defaultAddressId == clientAddress.id
                          ? AppStyle.whiteRegularText14Style()
                          : AppStyle.greyRegularText14Style(),
                    )
                  : SizedBox(),
              Text(
                "${clientAddress.streetName ?? ""}, ${clientAddress.doorNumber.toString() ?? ""}",
                style: defaultAddressId == clientAddress.id
                    ? AppStyle.whiteSemiBoldText16Style()
                    : AppStyle.greySemiBoldText16Style(),
              ),
              Text(
                "${clientAddress.neighborhoodName ?? ""}, ${clientAddress.cityName}",
                style: defaultAddressId == clientAddress.id
                    ? AppStyle.whiteRegularText14Style()
                    : AppStyle.greyRegularText14Style(),
              ),
              (clientAddress.complement != null &&
                      clientAddress.complement != "")
                  ? Text(
                      clientAddress.complement,
                      style: defaultAddressId == clientAddress.id
                          ? AppStyle.whiteRegularText14Style()
                          : AppStyle.greyRegularText14Style(),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
