import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/constants/enums.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/bottom_screen_large_button.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';
import 'package:to_faminto_client/services/api_service.dart';
import 'package:to_faminto_client/services/custom_text_formatter.dart';

import 'package:to_faminto_client/services/indentify_card_brand_service.dart';

class NewCardScreen extends StatefulWidget {
  final NavigationRoute returnTo;

  const NewCardScreen({this.returnTo});
  @override
  _NewCardScreenState createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _expireDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _cpfCpnjController = TextEditingController();
  final _apiService = ApiService();

  bool _isCardNumberValid = true;
  bool _isExpireDateValid = true;
  bool _isCvvValid = true;
  bool _isOwnerNameValid = true;
  bool _isCpfValid = true;

  String _cardBrand;
  String _cardNumber;
  String _cardType;
  String _expireDate;
  String _cpf;

  void _numberControllerOnChanged() {
    var cardNumber = _numberController.text;
    cardNumber = cardNumber.replaceAll(" ", "");
    setState(() {
      _cardBrand = identifyCardBrand(cardNumber);
    });
  }

  void _expireDateControllerOnChanged() {}
  void _cvvControllerOnChanged() {}
  void _ownerNameControllerOnChanged() {}
  void _cpfCpnjControllerOnChanged() {}

  bool validateCard() {
    _cardNumber = _numberController.text.replaceAll(" ", "");
    for (int i = 0; i < _cardNumber.length; i++) {
      _cardBrand = identifyCardBrand(_cardNumber.substring(0, i + 1));
    }

    return _cardBrand != "";
  }

  bool validateExpireDate() {
    var currentExpireData = _expireDateController.text;

    if (currentExpireData.length != 5) return false;

    var month = currentExpireData.substring(0, 2);
    var year = currentExpireData.substring(3, 5);

    var currentMonth = DateTime.now().month;
    var currentYear = DateTime.now().year;

    if (currentYear == int.parse("20$year") && int.parse(month) < currentMonth)
      return false;

    if (currentYear > int.parse("20$year")) return false;

    _expireDate = month + "/20" + year;

    return true;
  }

  bool validateCvv() {
    return _cvvController.text.length > 2;
  }

  bool validateOwnerName() {
    return _ownerNameController.text.length > 0;
  }

  bool validateCpf() {
    var cpf = _cpfCpnjController.text;

    RegExp re = new RegExp(r'(\D)');

    _cpf = cpf.replaceAll(re, "");
    cpf = cpf.replaceAll(re, "");

    if (cpf.length < 11) return false;

    var cpfList = cpf.split("");

    bool areAllDigitsTheSame = true;
    for (int i = 0; i < cpfList.length; i++) {
      if (cpfList[i] != cpfList[0]) {
        areAllDigitsTheSame = false;
        break;
      }
    }

    if (areAllDigitsTheSame) return false;

    int loopCpf(int loops) {
      var result = 0;
      for (int i = loops; i > 1; i--) {
        result += int.parse(cpfList[(i - loops).abs()]) * i;
      }
      return result;
    }

    bool verifyDigit(int loop, int digitToVerify) {
      var result = loopCpf(loop);
      var remaining = (result * 10) % 11;
      if (remaining == 10 || remaining == 11) remaining = 0;
      return remaining.toString() == cpf[digitToVerify];
    }

    if (!verifyDigit(10, 9)) return false;
    return (verifyDigit(11, 10));
  }

  bool _validateData() {
    setState(() {
      _isCardNumberValid = validateCard();
      _isExpireDateValid = validateExpireDate();
      _isCvvValid = validateCvv();
      _isCpfValid = validateCpf();
      _isOwnerNameValid = validateOwnerName();
    });

    return (_isCardNumberValid &&
        _isExpireDateValid &&
        _isCvvValid &&
        _isCpfValid &&
        _isOwnerNameValid &&
        _cardType != null);
  }

  void saveCard(BuildContext context) async {
    if (_validateData()) {
      final _customerName =
          await Provider.of<UserState>(context, listen: false).getUserName();
      final _card = await _apiService.saveCard(
        _customerName,
        _cardNumber,
        _ownerNameController.text,
        _expireDate,
        _cpf,
        _cardBrand,
        _cardType,
      );

      if (_card != null) {
        Provider.of<UserState>(context, listen: false).saveNewCard(_card);

        if (widget.returnTo != null) {
          Provider.of<RoutesState>(context, listen: false)
              .changeToCheckoutScreen();
        } else {
          Provider.of<RoutesState>(context, listen: false)
              .changeToCardsScreen();
        }
      }
    }
  }

  void onCreditDebitButtonPressed(int index) {
    setState(() {
      index == 0 ? _cardType = "CreditCard" : _cardType = "DebitCard";
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    _expireDateController.dispose();
    _cvvController.dispose();
    _ownerNameController.dispose();
    _cpfCpnjController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _numberController.addListener(_numberControllerOnChanged);
    _expireDateController.addListener(_expireDateControllerOnChanged);
    _cvvController.addListener(_cvvControllerOnChanged);
    _ownerNameController.addListener(_ownerNameControllerOnChanged);
    _cpfCpnjController.addListener(_cpfCpnjControllerOnChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: InkWell(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TopNotch("Novo Cartão"),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              NewCardTextFormField(
                                fieldName: "Numero do Cartão",
                                textInputType: TextInputType.numberWithOptions(
                                    signed: false, decimal: false),
                                autoFocus: true,
                                controller: _numberController,
                                inputFormatters: [
                                  CustomTextFormatter(
                                    mask: "xxxx xxxx xxxx xxxx",
                                    separators: [" "],
                                  ),
                                ],
                                errorText: !_isCardNumberValid
                                    ? "Numero Inválido"
                                    : null,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: NewCardTextFormField(
                                      fieldName: "Validade",
                                      textInputType: TextInputType.number,
                                      controller: _expireDateController,
                                      inputFormatters: [
                                        CustomTextFormatter(
                                          mask: "xx/xx",
                                          separators: ["/"],
                                        ),
                                      ],
                                      errorText: !_isExpireDateValid
                                          ? "Validade Inválida"
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: NewCardTextFormField(
                                      fieldName: "CVV",
                                      textInputType: TextInputType.number,
                                      controller: _cvvController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      errorText:
                                          !_isCvvValid ? "CVV Inválido" : null,
                                    ),
                                  ),
                                ],
                              ),
                              NewCardTextFormField(
                                fieldName: "Nome do titular",
                                textInputType: TextInputType.name,
                                controller: _ownerNameController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                ],
                                errorText:
                                    !_isOwnerNameValid ? "Nome Inválido" : null,
                              ),
                              NewCardTextFormField(
                                fieldName: "CPF",
                                textInputType: TextInputType.number,
                                controller: _cpfCpnjController,
                                inputFormatters: [
                                  CustomTextFormatter(
                                    mask: "xxx.xxx.xxx-xx",
                                    separators: [".", "-"],
                                  ),
                                ],
                                errorText: !_isCpfValid ? "CPF Inválido" : null,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CreditDebitButton(
                              onTap: () => onCreditDebitButtonPressed(0),
                              text: "Crédito",
                              isPressed:
                                  _cardType == "CreditCard" ? true : false,
                            ),
                            SizedBox(width: 10),
                            CreditDebitButton(
                              onTap: () => onCreditDebitButtonPressed(1),
                              text: "Débito",
                              isPressed:
                                  _cardType == "DebitCard" ? true : false,
                            ),
                          ],
                        ),
                        BottomScreenLargeButton(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "SALVAR",
                            style: AppStyle.whiteSemiBoldText16Style(),
                          ),
                          onPressed: (ctx) => saveCard(ctx),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreditDebitButton extends StatefulWidget {
  final Function onTap;
  final bool isPressed;
  final String text;

  const CreditDebitButton(
      {@required this.onTap, @required this.isPressed, @required this.text});

  @override
  _CreditDebitButtonState createState() => _CreditDebitButtonState();
}

class _CreditDebitButtonState extends State<CreditDebitButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 60,
          margin: EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            border: Border.all(
                color: widget.isPressed ? AppStyle.yellow : AppStyle.lightGrey),
          ),
          child: Text(
            widget.text,
            style: AppStyle.mediumGreyMediumText18Style(),
          ),
        ),
      ),
    );
  }
}

class NewCardTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final List inputFormatters;
  final String fieldName;
  final bool autoFocus;
  final TextAlign textAlign;
  final String errorText;

  const NewCardTextFormField({
    @required this.controller,
    @required this.fieldName,
    @required this.textInputType,
    this.autoFocus = false,
    this.inputFormatters,
    this.textAlign,
    @required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextFormField(
          autofocus: autoFocus,
          controller: controller,
          keyboardType: textInputType,
          style: AppStyle.mediumGreyMediumText18Style(),
          cursorColor: AppStyle.yellow,
          inputFormatters: [
            ...inputFormatters ?? [],
          ],
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            labelText: fieldName,
            fillColor: Colors.white,
            labelStyle: AppStyle.mediumGreyMediumText16Style(),
            errorText: errorText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppStyle.lightGrey,
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
                color: AppStyle.lightGrey,
                width: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
