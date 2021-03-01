import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserAddress {
  int id;
  final int userId;
  final int doorNumber;
  final String streetName;
  final String neighborhoodName;
  final String cityName;
  final String stateName;
  final String complement;
  final String type;
  String latitude;
  String longitude;

  UserAddress({
    this.id,
    @required this.userId,
    @required this.doorNumber,
    @required this.streetName,
    @required this.neighborhoodName,
    @required this.cityName,
    @required this.stateName,
    this.complement,
    @required this.type,
    this.latitude,
    this.longitude,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    RegExp vanillaAddressMatch = RegExp(
        r"(^.+?), (\d+) - (.+?), (.+?) - (.+?), (.+?), ([^]*)",
        caseSensitive: false);

    RegExp newAddressMatchWithReference = RegExp(
        r"(^.+?), (\d+) - (.+?), (.+?) - (\w{2}), (.+?)$",
        caseSensitive: false);

    RegExp newAddressMatch = RegExp(r"(^.+?), (\d+) - (.+?), (.+?) - (\w{2})$",
        caseSensitive: false);

    final segmentedVanillaAddress =
        vanillaAddressMatch.firstMatch(json['address']);

    RegExpMatch segmentedNewAddressWithReference;
    RegExpMatch segmentedNewAddress;

    if (segmentedVanillaAddress == null) {
      segmentedNewAddressWithReference =
          newAddressMatchWithReference.firstMatch(json['address']);

      if (segmentedNewAddressWithReference != null) {
        return UserAddress(
          id: json['id'],
          userId: json['user_id'],
          streetName: segmentedNewAddressWithReference.group(1),
          doorNumber: int.parse(segmentedNewAddressWithReference.group(2)),
          neighborhoodName: segmentedNewAddressWithReference.group(3),
          cityName: segmentedNewAddressWithReference.group(4),
          stateName: segmentedNewAddressWithReference.group(5),
          type: json['tag'],
          complement: json['landmark'],
          latitude: json['latitude'],
          longitude: json['longitude'],
        );
      } else {
        segmentedNewAddress = newAddressMatch.firstMatch(json['address']);
        if (segmentedNewAddress != null) {
          return UserAddress(
            id: json['id'],
            userId: json['user_id'],
            streetName: segmentedNewAddress.group(1),
            doorNumber: int.parse(segmentedNewAddress.group(2)),
            neighborhoodName: segmentedNewAddress.group(3),
            cityName: segmentedNewAddress.group(4),
            stateName: segmentedNewAddress.group(5),
            type: json['tag'],
            complement: json['landmark'],
            latitude: json['latitude'],
            longitude: json['longitude'],
          );
        }
      }
    } else {
      return UserAddress(
        id: json['id'],
        userId: json['user_id'],
        streetName: segmentedVanillaAddress.group(1),
        doorNumber: int.parse(segmentedVanillaAddress.group(2)),
        neighborhoodName: segmentedVanillaAddress.group(3),
        cityName: segmentedVanillaAddress.group(4),
        stateName: segmentedVanillaAddress.group(5),
        type: json['tag'],
        complement: json['landmark'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
    }

    return UserAddress(
      id: json['id'],
      userId: json['user_id'],
      streetName: "Erro",
      doorNumber: int.parse("0"),
      neighborhoodName: "Erro",
      cityName: "Erro",
      stateName: "Erro",
      type: json['tag'],
      complement: json['landmark'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  factory UserAddress.fromPrefs(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'],
      userId: json['userId'],
      doorNumber: json['doorNumber'],
      streetName: json['streetName'],
      neighborhoodName: json['neighborhoodName'],
      cityName: json['cityName'],
      stateName: json['stateName'],
      type: json['type'],
      complement: json['complement'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  String toJson() {
    return jsonEncode({
      "id": id,
      "userId": userId,
      "doorNumber": doorNumber,
      "streetName": streetName,
      "neighborhoodName": neighborhoodName,
      "cityName": cityName,
      "stateName": stateName,
      "type": type,
      "complement": complement,
      "latitude": latitude,
      "longitude": longitude,
    });
  }

  Map<String, String> transactionDeliveryAddress() {
    return {
      "Street": streetName,
      "Number": doorNumber.toString(),
      "Complement": complement,
      "City": cityName,
      "State": stateName,
      "Country": "BRA"
    };
  }

  String readableFullAddress() {
    if (complement != "" && complement != null) {
      return "$streetName, $doorNumber - $neighborhoodName, $cityName - $stateName, $complement";
    }
    return "$streetName, $doorNumber - $neighborhoodName, $cityName - $stateName";
  }

  String conversionAddress() {
    return "$streetName, $doorNumber, $neighborhoodName, $cityName, $stateName, Brazil";
  }
}
