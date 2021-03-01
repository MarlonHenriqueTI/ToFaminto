class WalletTransaction {
  final int id;

  /// 1 means withdraw
  ///
  /// 0 means deposit
  final int typeInt;
  final String type;
  final double amount;
  final bool confirmed;
  final String description;
  final String createdAt;

  WalletTransaction({
    this.id,
    this.typeInt,
    this.type,
    this.amount,
    this.confirmed,
    this.description,
    this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    final String fullDate = json['created_at'];
    final String day = fullDate.substring(8, 10);
    final String month = fullDate.substring(5, 7);
    final String year = fullDate.substring(0, 4);

    return WalletTransaction(
      id: json['id'],
      typeInt: json['type'] == "withdraw" ? 1 : 0,
      type: json['type'] == "withdraw" ? "Retirada" : "Depósito",
      amount: json['amount'] / 100,
      confirmed: json['confirmed'],
      description: json['meta']['description'],
      createdAt: "$day/$month/$year",
    );
  }

  factory WalletTransaction.fromPrefs(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      typeInt: json['typeInt'],
      type: json['type'],
      amount: json['amount'],
      confirmed: json['confirmed'],
      description: json['description'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "typeInt": typeInt,
      "type": type,
      "amount": amount,
      "confirmed": confirmed,
      "description": description,
      "createdAt": createdAt,
    };
  }
}
