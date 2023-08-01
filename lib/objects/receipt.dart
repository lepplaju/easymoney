/// Represents a transaction to be included in the invoice
class Receipt {
  final int id;
  DateTime date;
  int amount;
  String store;
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

  /// Creates a receipt from map
  ///
  /// Takes a [map] containing fields: id, date, amount, store, description
  /// and fileName
  Receipt.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        date = DateTime.parse(map['date']),
        amount = map['amount'],
        store = map['store'],
        description = map['description'],
        fileName = map['fileName'];

  /// Returns the date of the receipt as dd.mm.yyyy string
  String get dateOnly {
    return '${date.day}.${date.month}.${date.year}';
  }

  /// Returns the amount of the Receipt in euros
  double get euros {
    return amount / 100;
  }

  /// Returns the Receipt as a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'store': store,
      'description': description,
      'fileName': fileName,
    };
  }

  @override
  String toString() {
    return 'Receipt{'
        'id: $id, '
        'date: ${date.toIso8601String()}, '
        'amount: $amount, '
        'store: "$store", '
        'description: "$description", '
        'fileName: "$fileName"'
        '}';
  }
}
