import 'dart:io';

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
    _receipts.sort((r1, r2) => r2.date.compareTo(r1.date));
    return _receipts;
  }

  /// Loads all Receipts from database
  ///
  /// Requires [profileId] of the profile whose receipts will be fetched.
  Future<void> fetchReceipts({required int? profileId}) async {
    if (profileId == null) return;
    _receipts.clear();
    _receipts.addAll(await _receiptRepository.getReceipts(profileId));
    notifyListeners();
  }

  /// Adds a new Receipt
  ///
  /// Takes the [date] of the receipt, [store], optional [description],
  /// [amount], a receipt [file] and a [profileId] for which the receipt
  /// belongs to.
  Future<Receipt> addReceipt({
    required DateTime date,
    required String store,
    String description = '',
    required double amount,
    required XFile file,
    required int profileId,
  }) async {
    // TODO Throw error if not jpg or pdf
    if (!file.name.endsWith('.jpg')) {
      throw Exception('Wrong file format');
    }
    final id = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$id${file.name.substring(file.name.lastIndexOf('.'))}';
    final receipt = Receipt(
      id: id,
      date: DateUtils.dateOnly(date),
      amount: (amount * 100).round(),
      store: store,
      description: description,
      fileName: fileName,
      profileId: profileId,
    );

    // TODO Handle error
    await _receiptRepository.addReceipt(receipt: receipt, file: file);
    _receipts.add(receipt);
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

  /// Deletes all of the Receipts
  Future<void> deleteAllReceipts() async {
    for (var receipt in _receipts) {
      await _receiptRepository.deleteReceipt(receipt);
    }
    _receipts.clear();
    notifyListeners();
  }

  /// Gets the files of the receipts
  Future<List<File>> getReceiptFiles() async {
    final files = <File>[];
    for (var receipt in receipts) {
      // TODO Improve performance by waiting all the receipts
      files.add(await _receiptRepository.getReceiptFile(receipt.fileName));
    }
    return files;
  }

  /// Returns the receipt file of a [receipt]
  Future<dynamic> getReceiptImage(Receipt receipt) async {
    try {
      return await _receiptRepository.getReceiptImage(receipt.fileName);
      // TODO Catch different errors
    } catch (e) {
      // TODO Log
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}
