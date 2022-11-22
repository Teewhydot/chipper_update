import 'dart:convert';

import 'package:chipper_update/constants.dart';
import 'package:chipper_update/transaction_card.dart';
import 'package:chipper_update/transactions_model.dart';
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
  String apiKey = 'ckey_b1471e9db28b45e1bc29b690784';
  String ethAddress = '0xeA3d9B4743e20CE41777149A16e4eC97185d1487';
  List<Transaction> transactionList = [];

  Future getTransactions() async {
    // var headers = {
    //   'Authorization': 'Basic Y2tleV9iMTQ3MWU5ZGIyOGI0NWUxYmMyOWI2OTA3ODQ6'
    // };
    // var request = http.Request(
    //     'GET',
    //     Uri.parse(
    //         'https://api.covalenthq.com/v1/1/address/$ethAddress/transactions_v2/?quote-currency=USD&format=JSON&block-signed-at-asc=true&no-logs=true&page-size=1200&key=$apiKey')
    //     //
    //     // Uri.parse(
    //     //     'https://api.covalenthq.com/v1/1/address/$ethAddress/transactions_v2/')
    //     //
    //     );
    // request.headers.addAll(headers);
    // http.StreamedResponse response = await request.send();
    // if (response.statusCode == 200) {
    //   var responseString = await response.stream.bytesToString();
    //   final decodedResult = jsonDecode(responseString);
    //   var items = decodedResult['data']['items'];
    //   print('All items in the items list are $items');
    //   print(transactionList);
    //   print(await response.stream.bytesToString());
    // } else {
    //   print(response.reasonPhrase);
    // }


    http.Response response1 = await http.get(Uri.parse('https://api.covalenthq.com/v1/1/address/$ethAddress/transactions_v2/?quote-currency=USD&format=JSON&block-signed-at-asc=true&no-logs=true&page-size=1200&key=$apiKey'));
    if (response1.statusCode == 200) {
      var response = await jsonDecode(response1.body);
      var listOfPlayLists = response['data']['items'];
      for (var data in listOfPlayLists) {
      }
      print(listOfPlayLists);
    } else {}
  }


  @override
  void initState() {
    chipperFuture = getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getTransactions();
        },
        child: const Icon(Icons.add),
      ),
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
                'Something went wrong',
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
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
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
          }),
    );
  }
}
