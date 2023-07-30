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
  /// Takes unique [id], [date] of the receipt, [amount] of the receipt,
  /// [store] from which the receipt is from, [description] about
  /// the receipt and [fileName] of the attached receipt file.
  Receipt({
    required this.id,
    required this.date,
    required this.amount,
    required this.store,
    required this.description,
    required this.fileName,
  });

  /// Returns the date of the receipt as dd.mm.yyyy string
  String get dateOnly {
    return '${date.day}.${date.month}.${date.year}';
  }
}
