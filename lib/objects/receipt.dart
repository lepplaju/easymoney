/// Represents a transaction to be included in the invoice
class Receipt {
  DateTime date;
  final double amount;
  final String store;
  String description;
  // TODO Add pictures

  /// Creates Receipt
  ///
  /// Takes [date] of the receipt, [amount] of the receipt, [store] from
  /// which the receipt is from and [description] about the receipt
  Receipt({
    required this.date,
    required this.amount,
    required this.store,
    required this.description,
  });
}
