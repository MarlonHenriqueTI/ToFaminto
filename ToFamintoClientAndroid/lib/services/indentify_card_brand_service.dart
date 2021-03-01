List<String> rangeString(int start, int end) {
  List<String> stringRange = [];
  for (int i = start; i <= end; i++) {
    stringRange.add(i.toString());
  }
  return stringRange;
}

List visaStartDigits = ["4"];
List mastercardStartDigits = [
  ...rangeString(2221, 2720),
  "51",
  "52",
  "53",
  "54",
  "55",
];
List dinersStartDigits = ["30", "36", "38"];
List eloStartDigits = [
  "636368",
  "438935",
  "504175",
  "451416",
  "509048",
  "509067",
  "509049",
  "509069",
  "509050",
  "509074",
  "509068",
  "509040",
  "509045",
  "509051",
  "509046",
  "509066",
  "509047",
  "509042",
  "509052",
  "509043",
  "509064",
  "509040",
  "36297",
  "5067",
  "4576",
  "4011",
];
List americanExpressStartDigits = ["34", "37"];
List discoverStartDigits = [
  "6011",
  ...rangeString(622126, 622925),
  "644",
  "645",
  "646",
  "647",
  "648",
  "649",
  "65"
];
List auraStartDigits = ["50"];
List jcbStartDigits = rangeString(3528, 3589);
List hipercardStartDigits = ["69", "60"];

List visaMaxDigits = [13, 16];
List mastercardMaxDigits = [16];
List dinerMaxDigits = [14, 16];
List eloMaxDigits = [16];
List americanExpressDigits = [15];
List discoverMaxDigits = [16];
List auraMaxDigits = [16];
List jcbMaxDigits = [16];
List hipercardMaxDigits = [13, 16];

String _cardBrand;

void checkDigits(int len, String _cardNumber, List brandDigits, String brand) {
  for (final digits in brandDigits) {
    if (digits.length == len) {
      if (_cardNumber == digits) {
        _cardBrand = brand;
      }
    }
  }
}

String identifyCardBrand(String _cardNumber) {
  if (_cardNumber.length == 1) {
    checkDigits(1, _cardNumber, visaStartDigits, "Visa");
  } else if (_cardNumber.length == 2) {
    checkDigits(2, _cardNumber, dinersStartDigits, "Diners");
    checkDigits(2, _cardNumber, mastercardStartDigits, "Master");
    checkDigits(2, _cardNumber, discoverStartDigits, "Discover");
    checkDigits(2, _cardNumber, auraStartDigits, "Aura");
    checkDigits(2, _cardNumber, hipercardStartDigits, "Hipercard");
    checkDigits(2, _cardNumber, americanExpressStartDigits, "Amex");
  } else if (_cardNumber.length == 3) {
    checkDigits(3, _cardNumber, discoverStartDigits, "Discover");
  } else if (_cardNumber.length == 4) {
    checkDigits(4, _cardNumber, jcbStartDigits, "JCB");
    checkDigits(4, _cardNumber, mastercardStartDigits, "Master");
    checkDigits(4, _cardNumber, eloStartDigits, "Elo");
    checkDigits(4, _cardNumber, discoverStartDigits, "Discover");
  } else if (_cardNumber.length == 5) {
    checkDigits(5, _cardNumber, eloStartDigits, "Elo");
  } else if (_cardNumber.length == 6) {
    checkDigits(6, _cardNumber, discoverStartDigits, "Discover");
    checkDigits(6, _cardNumber, eloStartDigits, "Elo");
  } else if (_cardNumber.length == 13) {
    if (_cardBrand != "Visa" && _cardBrand != "Hipercard") {
      return "";
    }
  } else if (_cardNumber.length == 14) {
    if (_cardBrand != "Diners") {
      return "";
    }
  } else if (_cardNumber.length == 15) {
    if (_cardBrand != "Amex") {
      return "";
    }
  } else if (_cardNumber.length == 16) {
    if (_cardBrand == "Visa" ||
        _cardBrand == "Diners" ||
        _cardBrand == "Elo" ||
        _cardBrand == "Discover" ||
        _cardBrand == "Aura" ||
        _cardBrand == "JCB" ||
        _cardBrand == "Master" ||
        _cardBrand == "Hipercard") {
    } else {
      return "";
    }
  }
  return _cardBrand;
}
