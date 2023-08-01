import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:sqflite/sqflite.dart';

import '../objects/receipt.dart';

/// Manages receipts which are not part of any invoice
class ProviderReceipts with ChangeNotifier {
  ProviderReceipts({required this.db});
  Database db;

  static const _receiptsTableName = 'receipts';
  final List<Receipt> _receipts = [];

  /// Returns a list of all the Receipts
  List<Receipt> get receipts {
    _receipts.sort((r1, r2) => r1.date.compareTo(r2.date));
    return _receipts;
  }

  /// Loads all Receipts from database
  Future<void> fetchReceipts() async {
    _receipts.clear();
    final data = await db.query(_receiptsTableName);
    for (var map in data) {
      _receipts.add(Receipt.fromMap(map));
    }
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
    final fileName = await saveReceiptFile(file, id);
    final receipt = Receipt(
      id: id,
      date: DateUtils.dateOnly(date),
      amount: (amount * 100).toInt(),
      store: store,
      description: description,
      fileName: fileName,
    );
    _receipts.add(receipt);
    await db.insert(_receiptsTableName, receipt.toMap());
    notifyListeners();
    return receipt;
  }

  /// Returns a path where the receipt files will be saved.
  Future<String> _getPath() async {
    const String receiptPath = '/receipts';
    final path =
        '${(await getApplicationDocumentsDirectory()).path}$receiptPath';
    if (!Directory(path).existsSync()) {
      Directory(path).createSync();
    }
    return path;
  }

  /// Saves a receipt file of a Receipt
  ///
  /// Takes the [file] to be saved and the id of the receipt for which it
  /// belongs to.
  Future<String> saveReceiptFile(XFile file, int id) async {
    final path = await _getPath();
    if (!Directory(path).existsSync()) {
      Directory(path).createSync();
    }
    final fileType = file.name.substring(file.name.lastIndexOf('.'));
    await file.saveTo('$path/$id$fileType');

    return '$id$fileType';
  }

  /// Returns the receipt file of a [receipt]
  Future<dynamic> getReceiptFile(Receipt receipt) async {
    final path = await _getPath();
    final file = XFile('$path/${receipt.fileName}');
    try {
      final fileType = file.name.substring(file.name.lastIndexOf('.'));
      switch (fileType) {
        case '.jpg':
          Image image = Image.file(File(file.path));
          return image;
        case '.pdf':
          PdfDocument doc = await PdfDocument.openFile(file.path);
          return doc;
        default:
          return Future.error(Exception('Incorrect filetype \'$fileType\''));
      }
      // TODO Catch different errors
    } catch (e) {
      // TODO Log
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}
