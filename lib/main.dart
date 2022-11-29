// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:chipper_update/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future chipperFuture;
  String covalentApiKey = 'ckey_b1471e9db28b45e1bc29b690784';
  String ethplorerApiKey = 'EK-tu6gX-nQYCG5d-swLNy';
  String ethAddress = '0xeA3d9B4743e20CE41777149A16e4eC97185d1487';
  String ethplorerUrl =
      'https://api.ethplorer.io/getAddressInfo/0xeA3d9B4743e20CE41777149A16e4eC97185d1487?apiKey=EK-tu6gX-nQYCG5d-swLNy';
  String covalentUrl =
      'https://api.covalenthq.com/v1/1/address/0xeA3d9B4743e20CE41777149A16e4eC97185d1487/transactions_v2/?quote-currency=USD&format=JSON&block-signed-at-asc=false&no-logs=false&page-size=10000&key=ckey_b1471e9db28b45e1bc29b690784';
  var ethBalance;
  var usdcBalance;
  var usdtBalance;

  List<String> dates = [];
  List<String> transactionsToday = [];
  List<String> transactionsYesterday = [];
  List<String> transactionsTwoDaysAgo = [];
  List<String> transactionsThreeDaysAgo = [];
  List<String> transactionsFourDaysAgo = [];
  List<String> transactionsFiveDaysAgo = [];
  final twoDaysAgoDate = DateTime.now().subtract(const Duration(days: 2)).toString();
  final threeDaysAgoDate = DateTime.now().subtract(const Duration(days: 3)).toString();
  final fourDaysAgoDate = DateTime.now().subtract(const Duration(days: 4)).toString();
  final fiveDaysAgoDate = DateTime.now().subtract(const Duration(days: 5)).toString();


  final yesterdayDate =
      DateTime.now().subtract(const Duration(days: 1)).day.toString();
  final todayDate = DateTime.now().day;

  Future getTransactionFromCovalent() async {
    try {
      http.Response response1 = await http.get(Uri.parse(covalentUrl));
      if (response1.statusCode == 200) {
       await getBalancesFromEthplorer();
        var response = await jsonDecode(response1.body);
        var listOfTransactions = response['data']['items'];
        for (var data in listOfTransactions) {
          var date = data['block_signed_at'];
          var todayDateFromResponse = date.substring(8, 10);
          if (todayDateFromResponse.toString() == todayDate.toString()) {
            transactionsToday.add(todayDateFromResponse);
          }

          if (todayDateFromResponse.toString() == yesterdayDate) {
            transactionsYesterday.add(todayDateFromResponse);
          }
          if (todayDateFromResponse.toString() == twoDaysAgoDate){
            transactionsTwoDaysAgo.add(todayDateFromResponse);
          }
          if (todayDateFromResponse.toString() == threeDaysAgoDate){
            transactionsThreeDaysAgo.add(todayDateFromResponse);
          }
          if (todayDateFromResponse.toString() == fourDaysAgoDate){
            transactionsFourDaysAgo.add(todayDateFromResponse);
          }
          if (todayDateFromResponse.toString() == fiveDaysAgoDate){
            transactionsFiveDaysAgo.add(todayDateFromResponse);
          }
        }
      }

    } catch (e) {
      throw Exception('Error');
    }
  }
  Future getBalancesFromEthplorer()async {
    try {
      http.Response response1 = await http.get(Uri.parse(ethplorerUrl));
      if (response1.statusCode == 200) {
        var response = await jsonDecode(response1.body);
      //  var listOfTransactions = response['transactions'];
         ethBalance = response['ETH']['balance'];
         usdcBalance = response['tokens'][0]['balance'];
         usdtBalance = response['tokens'][2]['balance'];
      }
    } catch (e) {
      throw Exception('Error');
    }

  }
  @override
  void initState() {
    chipperFuture = getTransactionFromCovalent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chipper'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: chipperFuture,
          initialData: const Center(
              child: Text(
            'Loading',
            style: mediumBlackTextStyle,
          )),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Text(
                'Problem dey',
                style: mediumBlackTextStyle,
              ));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  children: [
                    addVerticalSpacing(200),
                    const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ],
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card showing the number of transactions today
                Container(
                  height: 300,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions Today',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            transactionsToday.length.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions Yesterday',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            transactionsYesterday.length.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions 2 Days Ago',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            transactionsTwoDaysAgo.length.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions 3 Days Ago',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            transactionsThreeDaysAgo.length.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions 4 Days Ago',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            transactionsFourDaysAgo.length.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions 5 Days Ago',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            transactionsFiveDaysAgo.length.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Card showing balance of ETH
                Container(
                  height: 150,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ETH Balance',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            ethBalance.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'USDC Balance',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            usdcBalance.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'USDT Balance',
                            style: mediumBlackTextStyle,
                          ),
                          Text(
                            usdtBalance.toString(),
                            style: mediumBlackTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}