import 'package:flutter/material.dart';


class TransactionCard extends StatelessWidget {
  final String sender;
  final String receiver;
  final double amount;
  final String date;

  const TransactionCard({
    Key? key,
    required this.amount,
    required this.receiver,
    required this.sender,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: Card(
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
            Column(
              children:[
                Text(date),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
