
class Transaction {
  final String receiver;
  final String sender;
  final double amount;
  final String date;

  Transaction({
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.date,
  });
}