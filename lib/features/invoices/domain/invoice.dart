class Invoice {
  int id;
  int profileId;
  DateTime date;
  String target;
  String name;
  int amount;
  String fileName;

  Invoice({
    required this.id,
    required this.profileId,
    required this.date,
    required this.target,
    required this.name,
    required this.amount,
    required this.fileName,
  });

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

  String get euros {
    return (amount / 100).toStringAsFixed(2);
  }

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
