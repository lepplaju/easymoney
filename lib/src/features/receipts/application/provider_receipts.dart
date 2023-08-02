import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/receipt.dart';
import '../data/receipt_repository.dart';

/// Manages receipts which are not part of any invoice
class ProviderReceipts with ChangeNotifier {
  final ReceiptRepository _receiptRepository = ReceiptRepository();
  final List<Receipt> _receipts = [];

  /// Returns a list of all the Receipts
  List<Receipt> get receipts {
    _receipts.sort((r1, r2) => r1.date.compareTo(r2.date));
    return _receipts;
  }

  /// Loads all Receipts from database
  Future<void> fetchReceipts() async {
    _receipts.clear();
    _receipts.addAll(await _receiptRepository.getReceipts());
    notifyListeners();
  }

  /// Adds a new Receipt
  ///
  /// Takes the [date] of the receipt, [store], optional [description],
  /// [amount] and a receipt [file].
  Future<Receipt> addReceipt({
    required DateTime date,
    required String store,
    String description = '',
    required double amount,
    required XFile file,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$id${file.name.substring(file.name.lastIndexOf('.'))}';

    final receipt = Receipt(
      id: id,
      date: DateUtils.dateOnly(date),
      amount: (amount * 100).toInt(),
      store: store,
      description: description,
      fileName: fileName,
    );

    _receipts.add(receipt);
    // TODO Handle error
    await _receiptRepository.addReceipt(receipt: receipt, file: file);
    notifyListeners();

    return receipt;
  }

  /// Deletes a [receipt]
  Future<void> deleteReceipt(Receipt receipt) async {
    try {
      await _receiptRepository.deleteReceipt(receipt);
      _receipts.removeWhere((element) => element.id == receipt.id);
      notifyListeners();
    } catch (e) {
      // TODO Handle errors
      return Future.error(e);
    }
  }

  /// Returns the receipt file of a [receipt]
  Future<dynamic> getReceiptFile(Receipt receipt) async {
    try {
      return await _receiptRepository.getReceiptFile(receipt.fileName);
      // TODO Catch different errors
    } catch (e) {
      // TODO Log
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}
