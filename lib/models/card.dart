import 'dart:convert';

import 'package:flutter/foundation.dart';

class BankCard {
  final int id;
  final String holderName;
  final String number;
  final String expireDate;
  final bool isCredit;

  const BankCard({
    @required this.id,
    @required this.holderName,
    @required this.number,
    @required this.expireDate,
    @required this.isCredit,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) {
    return BankCard(
      id: json['id'],
      holderName: json['holderName'],
      number: json['cardNumber'],
      expireDate: json['date'],
      isCredit: json['isCredit'],
    );
  }

  factory BankCard.fromApiJson(Map<String, dynamic> json) {
    return BankCard(
      id: json['id'],
      holderName: json['holder_name'],
      number: json['last_digits'],
      expireDate: json['expire_date'],
      isCredit: json['type'] == 'CreditCard',
    );
  }

  String toJson() {
    return jsonEncode({
      "id": id,
      "holderName": holderName,
      "cardNumber": number,
      "date": expireDate,
      "isCredit": isCredit,
    });
  }
}
