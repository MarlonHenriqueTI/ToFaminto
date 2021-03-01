class PromoSlide {
  final String image;

  PromoSlide(this.image);

  factory PromoSlide.fromJson(Map<String, dynamic> json) {
    return PromoSlide(
      "https://www.tofaminto.com/${json['image']}",
    );
  }
}
