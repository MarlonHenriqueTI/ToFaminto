import 'package:flutter/material.dart';

class AppStyle {
  static const yellow = Color(0xffFFBA00);
  static const yellowGradientStart = Color(0xffFFBA00);
  static const yellowGradientEnd = Color(0xffFFD93B);
  static const grey = Color(0xff7E7E7E);
  static const mediumGrey = Color(0xff646464);
  static const lightGrey = Color(0xffEEEEEE);
  static const whiteBackground = Color(0xffffffff);
  static const darkGrey = Color(0xff404040);

  static TextStyle whiteRegularText13Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 13.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteRegularText14Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteRegularText16Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteRegularText30Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyRegularText16Style() {
    return const TextStyle(
      color: grey,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greenRegularText16Style() {
    return const TextStyle(
      color: Colors.green,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle redRegularText16Style() {
    return const TextStyle(
      color: Colors.red,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyRegularText16StyleWithCustomColor(final Color color) {
    return TextStyle(
      color: color,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyRegularText14Style() {
    return const TextStyle(
      color: grey,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyRegularText14Height1dot5Style() {
    return const TextStyle(
      color: grey,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
      height: 1.5,
    );
  }

  static TextStyle greyRegularText15Style() {
    return const TextStyle(
      color: grey,
      fontSize: 15.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle darkGreyRegularText15Style() {
    return const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15,
      color: darkGrey,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle mediumGreyRegularTex16tStyle() {
    return const TextStyle(
      color: mediumGrey,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyMediumText14Style() {
    return const TextStyle(
      color: grey,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle redMediumText14Style() {
    return const TextStyle(
      color: Colors.red,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyMediumText16Style() {
    return const TextStyle(
      color: grey,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyMediumText20Style() {
    return const TextStyle(
      color: grey,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle yellowRegularTextStyle() {
    return const TextStyle(
      color: yellow,
      fontSize: 13.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle yellowMediumText16Style() {
    return const TextStyle(
      color: yellow,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle redMediumText16Style() {
    return const TextStyle(
      color: Colors.red,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greenMediumText16Style() {
    return const TextStyle(
      color: Colors.green,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle pillWhiteRegularTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 15.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle pillYellowRegularTextStyle() {
    return const TextStyle(
      color: yellow,
      fontSize: 15.0,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteBoldTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteMediumTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle loginRegisterFontStyle() {
    return const TextStyle(
      color: yellow,
      fontSize: 17.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteMediumText16Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumGreyMediumTex14tStyle() {
    return const TextStyle(
      color: mediumGrey,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumGreyMediumText16Style() {
    return const TextStyle(
      color: mediumGrey,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumGreyMediumText18Style() {
    return const TextStyle(
      color: mediumGrey,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumOpacityGreyMediumText14Style() {
    return TextStyle(
      color: grey.withOpacity(0.5),
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumGreyMediumText14ItalicStyle() {
    return const TextStyle(
      color: mediumGrey,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumGreyRegularText14ItalicStyle() {
    return const TextStyle(
      color: mediumGrey,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumRedMediumText16Style() {
    return const TextStyle(
      color: Colors.red,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteSemiBoldText14Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteSemiBoldText16Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteSemiBoldText20Style() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greySemiBoldText16Style() {
    return const TextStyle(
      color: grey,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greySemiBoldText20Style() {
    return const TextStyle(
      color: grey,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle mediumGreySemiBoldText20Style() {
    return const TextStyle(
      color: mediumGrey,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greyBoldText20Style() {
    return const TextStyle(
      color: grey,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle greenBoldText20Style() {
    return const TextStyle(
      color: Colors.green,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    );
  }

  static TextStyle whiteBlackText24ItalicStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      fontFamily: 'Montserrat',
    );
  }
}
