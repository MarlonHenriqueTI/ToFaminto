import 'package:flutter/material.dart';

import 'address_text_form_field.dart';

class AddressFrom extends StatelessWidget {
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController neighborhoodController;
  final TextEditingController streetController;
  final TextEditingController doorNumberController;
  final TextEditingController referenceController;
  final TextEditingController typeController;
  final bool isManual;

  AddressFrom({
    this.stateController,
    this.cityController,
    this.neighborhoodController,
    this.streetController,
    this.doorNumberController,
    this.referenceController,
    this.typeController,
    this.isManual,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            AddressTextFormField(
              fieldName: "Estado",
              controller: stateController,
              autofocus: isManual,
            ),
            SizedBox(height: 10),
            AddressTextFormField(
              fieldName: "Cidade",
              controller: cityController,
            ),
            SizedBox(height: 10),
            AddressTextFormField(
              fieldName: "Bairro",
              controller: neighborhoodController,
            ),
            SizedBox(height: 10),
            AddressTextFormField(
              fieldName: "Logradouro",
              controller: streetController,
            ),
            SizedBox(height: 10),
            AddressTextFormField(
              fieldName: "Numero",
              keyboardType: TextInputType.number,
              controller: doorNumberController,
              autofocus:
                  doorNumberController.text == "" && !isManual ? true : false,
            ),
            SizedBox(height: 10),
            AddressTextFormField(
              fieldName: "Tipo (Casa/Trabalho)",
              controller: typeController,
              keyboardType: TextInputType.text,
              autofocus:
                  doorNumberController.text == "" && !isManual ? false : true,
            ),
            SizedBox(height: 10),
            AddressTextFormField(
              fieldName: "Referencia",
              keyboardType: TextInputType.text,
              controller: referenceController,
            ),
          ],
        ),
      ),
    );
  }
}
