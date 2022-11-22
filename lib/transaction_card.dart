import 'package:flutter/material.dart';


class TransactionCard extends StatelessWidget {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  const TransactionCard({
    Key? key,
    required this.id,
    required this.title,
    required this.amount,
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
              children: const [
                Text('Transaction'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
