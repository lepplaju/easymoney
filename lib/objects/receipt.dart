/// Represents a transaction to be included in the invoice
class Receipt {
  final String id;
  DateTime date;
  final double amount;
  final String store;
  String description;
  String fileName;

  /// Creates Receipt
  ///
  /// Takes [date] of the receipt, [amount] of the receipt, [store] from
  /// which the receipt is from and [description] about the receipt
  Receipt({
    required this.id,
    required this.date,
    required this.amount,
    required this.store,
    required this.description,
    required this.fileName,
  });

  String get dateOnly {
    return '${date.day}.${date.month}.${date.year}';
  }
}
