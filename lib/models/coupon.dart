class Coupon {
  final String discountType;
  final double amount;
  final String code;

  const Coupon(this.discountType, this.amount, this.code);

  bool isTypeAmount() => discountType == 'AMOUNT';
  bool isTypePercentage() => !isTypeAmount();

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      json['discount_type'],
      json['discount'],
      json['code'],
    );
  }
}
