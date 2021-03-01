import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/app_style.dart';

class AddressTextFormField extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;
  final bool autofocus;
  final TextInputType keyboardType;
  const AddressTextFormField({
    @required this.fieldName,
    @required this.controller,
    this.autofocus = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: AppStyle.mediumGreyMediumText16Style(),
      cursorColor: AppStyle.yellow,
      autofocus: autofocus,
      keyboardType: keyboardType ?? TextInputType.streetAddress,
      decoration: InputDecoration(
        labelText: fieldName,
        fillColor: Colors.white,
        labelStyle: AppStyle.mediumGreyMediumText16Style(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyle.yellow,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyle.yellow,
            width: 1.0,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyle.yellow,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
