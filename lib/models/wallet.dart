import 'wallet_transaction.dart';

class Wallet {
  final double balance;
  List<WalletTransaction> transactions;

  Wallet({this.balance, this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json,
      {bool fromPrefs = false, bool onlyBalance = false}) {
    if (onlyBalance || json['transactions'] == null) {
      return Wallet(
        balance: double.parse(json['balance'].toString()),
      );
    }

    List<WalletTransaction> walletTransactions = [];

    for (final Map<String, dynamic> transaction in json['transactions']) {
      if (fromPrefs)
        walletTransactions.add(WalletTransaction.fromPrefs(transaction));
      else
        walletTransactions.add(WalletTransaction.fromJson(transaction));
    }

    return Wallet(
      balance: double.parse(json['balance'].toString()),
      transactions: walletTransactions,
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> jsonTransactions = [];
    for (final WalletTransaction transaction in transactions ?? []) {
      jsonTransactions.add(transaction.toMap());
    }

    return {
      "balance": balance,
      "transactions": jsonTransactions,
    };
  }
}
