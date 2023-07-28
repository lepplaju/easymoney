import 'package:flutter/material.dart';

import '../objects/receipt.dart';

/// Manages receipts which are not part of any invoice
class ProviderReceipts with ChangeNotifier {
  final List<Receipt> _receipts = //[];
      // For testing
      [
    Receipt(
      date: DateTime(2023, 4, 24),
      amount: 35.99,
      store: 'Prisma',
      description: 'Allasbileiden tarvikkeita',
    ),
    Receipt(
      date: DateTime(2023, 4, 24),
      amount: 6.99,
      store: 'Mestarin Herkku',
      description: 'Unohtuneita tarvikkeita',
    ),
    Receipt(
      date: DateTime(2023, 6, 12),
      amount: 199.99,
      store: 'K-Market',
      description: 'Ben & Jerry',
    ),
    Receipt(
      date: DateTime(2023, 7, 30),
      amount: 499.99,
      store: 'Kuntokauppa',
      description: 'Rautaa salille',
    ),
  ];

  /// Returns a list of all the Receipts
  List<Receipt> get receipts {
    _receipts.sort((r1, r2) => r1.date.compareTo(r2.date));
    return _receipts;
  }
}
