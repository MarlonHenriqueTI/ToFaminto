import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/wallet.dart';
import 'package:to_faminto_client/models/wallet_transaction.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';
import 'package:to_faminto_client/services/api_service.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _apiService = ApiService();
  Future<dynamic> futureWallet;

  @override
  void initState() {
    futureWallet = _apiService.walletTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TopNotch(
              "Carteira Digital",
              margin: EdgeInsets.only(bottom: 20),
            ),
            Expanded(
              child: FutureBuilder<dynamic>(
                future: futureWallet,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data is ApiError) {
                      final ApiError apiError = snapshot.data;
                      return Center(
                        child: Text(apiError.text),
                      );
                    } else if (snapshot.data is Wallet) {
                      Provider.of<UserState>(context, listen: false)
                          .updateWallet(snapshot.data);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WalletAmountWidget(
                              balance: snapshot.data.balance,
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                  itemCount: snapshot.data.transactions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TransactionWidget(
                                      key: UniqueKey(),
                                      transaction:
                                          snapshot.data.transactions[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WalletAmountWidget extends StatelessWidget {
  final double balance;

  const WalletAmountWidget({Key key, this.balance}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border.all(color: AppStyle.lightGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Disponível:",
            style: AppStyle.mediumGreyMediumText18Style(),
          ),
          SizedBox(height: 10),
          Text(
            "R\$ ${balance.toString()}",
            style: AppStyle.greenBoldText20Style(),
          ),
        ],
      ),
    );
  }
}

class TransactionWidget extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionWidget({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        border: Border.all(color: AppStyle.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.type,
                style: AppStyle.greyMediumText16Style(),
              ),
              Text(
                "R\$ ${transaction.amount.toString()}",
                style: transaction.typeInt == 1
                    ? AppStyle.redRegularText16Style()
                    : AppStyle.greenRegularText16Style(),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            transaction.description,
            style: AppStyle.greyRegularText15Style(),
          ),
          SizedBox(height: 12),
          Text(
            transaction.createdAt,
            style: AppStyle.greyRegularText15Style(),
          ),
        ],
      ),
    );
  }
}
