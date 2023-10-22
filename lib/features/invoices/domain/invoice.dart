/// Tells in which state the Invoice is in
enum Status { waiting, sent, paid }

/// Returns the Status enum corresponding the [status]
Status _getStatus(String status) {
  switch (status) {
    case 'waiting':
      return Status.waiting;
    case 'sent':
      return Status.sent;
    case 'paid':
      return Status.paid;
    default:
      throw Exception('Invalid-Status');
  }
}

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
  Status status;
  String fileName;

  /// Creates an invoice
  ///
  /// Requires unique [id], [profileId] of the profile to whom it
  /// belongs, [date] of the creation, [target] as who will be the
  /// invoices payer, [name] of the invoicer, [amount] of what the
  /// total is, [fileName] with which the invoice will be saved and
  /// optionaly the [status] of the invoice.
  Invoice({
    required this.id,
    required this.profileId,
    required this.date,
    required this.target,
    required this.name,
    required this.amount,
    this.status = Status.waiting,
    required this.fileName,
  });

  /// Creates an Invoice from a map
  ///
  /// Requires a [map] containing fields: id, profileId, date, target,
  /// name, amount, fileName and status.
  Invoice.fromMap({required Map<String, dynamic> map})
      : id = map['id'],
        profileId = map['profileId'],
        date = DateTime.parse(map['date']),
        target = map['target'],
        name = map['name'],
        amount = map['amount'],
        status = _getStatus(map['status']),
        fileName = map['fileName'];

  /// Returns the date of the invoice as dd.mm.yyyy string
  String get dateOnly {
    return '${date.day}.${date.month}.${date.year}';
  }

  /// Returns the amount in euros as a String
  String get euros {
    return (amount / 100).toStringAsFixed(2);
  }

  /// Returns the Status enum that comes next
  Status nextStatus() {
    switch (status.name) {
      case 'waiting':
        return Status.sent;
      case 'sent':
        return Status.paid;
      default:
        return Status.waiting;
    }
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
      'status': status.name,
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
        'status: ${status.name}, '
        'fileName: $fileName'
        '}';
  }
}
