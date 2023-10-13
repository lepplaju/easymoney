/// Represents a invoice that will be composed out of receipts
///
/// {@category Invoices}
class Invoice {
  int id;
  int profileId;
  DateTime date;
  String target;
  String name;
  int amount;
  String fileName;

  /// Creates an invoice
  ///
  /// Requires unique [id], [profileId] of the profile to whom it
  /// belongs, [date] of the creation, [target] as who will be the
  /// invoices payer, [name] of the invoicer, [amount] of what the
  /// total is and [fileName] with which the invoice will be saved.
  Invoice({
    required this.id,
    required this.profileId,
    required this.date,
    required this.target,
    required this.name,
    required this.amount,
    required this.fileName,
  });

  /// Creates an Invoice from a map
  ///
  /// Requires a [map] containing fields: id, profileId, date, target,
  /// name, amount and fileName.
  Invoice.fromMap({required Map<String, dynamic> map})
      : id = map['id'],
        profileId = map['profileId'],
        date = DateTime.parse(map['date']),
        target = map['target'],
        name = map['name'],
        amount = map['amount'],
        fileName = map['fileName'];

  /// Returns the date of the invoice as dd.mm.yyyy string
  String get dateOnly {
    return '${date.day}.${date.month}.${date.year}';
  }

  /// Returns the amount in euros as a String
  String get euros {
    return (amount / 100).toStringAsFixed(2);
  }

  /// Returns the Invoice as a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'date': date.toIso8601String(),
      'target': target,
      'name': name,
      'amount': amount,
      'fileName': fileName,
    };
  }

  @override
  String toString() {
    return '{'
        'id: $id, '
        'profileId: $profileId,'
        'date: $date, '
        'target: $target, '
        'name: $name, '
        'amount: $amount, '
        'fileName: $fileName'
        '}';
  }
}
