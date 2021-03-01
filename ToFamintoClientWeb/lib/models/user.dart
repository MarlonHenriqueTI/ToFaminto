import 'dart:convert';

import 'package:to_faminto_client/models/user_address.dart';
import 'package:to_faminto_client/models/wallet.dart';

class User {
  final int id;
  final String authToken;
  final String deliveryPin;
  bool isGuess;
  Wallet wallet;
  String name;
  String email;
  String phone;
  String identity;
  List<UserAddress> addresses;
  int defaultAddressId;
  String notificationToken;

  User({
    this.id,
    this.authToken,
    this.deliveryPin,
    this.isGuess,
    this.wallet,
    this.name,
    this.email,
    this.phone,
    this.identity,
    this.addresses,
    this.defaultAddressId,
    this.notificationToken,
  });

  factory User.guest() {
    return User(
      id: DateTime.now().millisecondsSinceEpoch,
      authToken: DateTime.now().millisecondsSinceEpoch.toString(),
      deliveryPin: DateTime.now().millisecondsSinceEpoch.toString(),
      isGuess: true,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      authToken: json['auth_token'],
      deliveryPin: json['delivery_pin'],
      wallet: Wallet.fromJson({"balance": json['wallet_balance']},
          onlyBalance: true),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      isGuess: false,
      addresses: null,
      defaultAddressId: json['default_address_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authToken': authToken,
      'deliveryPin': deliveryPin,
      'wallet': wallet?.toMap(),
      'name': name,
      'email': email,
      'phone': phone,
      'isGuess': isGuess,
      'addresses': addresses,
      'defaultAddressId': defaultAddressId,
      'notificationToken': notificationToken,
    };
  }

  factory User.fromPrefs(Map<String, dynamic> json) {
    List<UserAddress> addresses = [];

    for (final address in json['addresses'] ?? []) {
      addresses.add(UserAddress.fromPrefs(jsonDecode(address)));
    }
    Wallet wallet;
    if (json["wallet"] != null) {
      wallet = Wallet.fromJson(json['wallet'], fromPrefs: true);
    }

    return User(
      id: json['id'],
      authToken: json['authToken'],
      deliveryPin: json['deliveryPin'],
      wallet: wallet,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      isGuess: json['isGuess'],
      addresses: addresses,
      defaultAddressId: json['defaultAddressId'],
      notificationToken: json['notificationToken'],
    );
  }
}
