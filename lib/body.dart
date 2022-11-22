import 'dart:convert';

import 'package:chipper_update/constants.dart';
import 'package:chipper_update/transaction_card.dart';
import 'package:chipper_update/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChipperBody extends StatefulWidget {
  const ChipperBody({Key? key}) : super(key: key);

  @override
  State<ChipperBody> createState() => _ChipperBodyState();
}

class _ChipperBodyState extends State<ChipperBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chipperFuture = getTransactions();
  }

  late Future chipperFuture;
  String apiKey = 'ckey_b1471e9db28b45e1bc29b690784';
  String ethAddress = '0xeA3d9B4743e20CE41777149A16e4eC97185d1487';
  List<Transaction> transactionList = [];
  Future getTransactions() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.covalenthq.com/v1/1/address/$ethAddress/transactions_v2/?key=$apiKey'));
      if (response.statusCode == 200) {
        var res1 = await jsonDecode(response.body);
        var res2 = res1['data']['items'][0];
        for (var data in res2) {
          var id = data['block_signed_at'];
          var title = data['block_height'];
          var amount = data['id'];
          var date = data['tracklist'];
          print(date);
          final Transaction transaction =
              Transaction(id: id, title: title, amount: amount, date: date);
          transactionList.add(transaction);
        }
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chipperFuture,
        initialData: const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.white,
        )),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text(
              'Something went wrong',
            ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: [
                  addVerticalSpacing(200),
                  CircularProgressIndicator(
                    color: textColor,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactionList.length,
            itemBuilder: (context, index) {
              return TransactionCard(
                id: transactionList[index].id,
                title: transactionList[index].title,
                amount: transactionList[index].amount,
                date: transactionList[index].date,
              );
            },
          );
        });
  }
}
