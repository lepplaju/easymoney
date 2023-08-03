import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pdf_render/pdf_render.dart';

import '../domain/receipt.dart';
import '../../../utils/database.dart';
import '../../../utils/file_operations.dart';

/// Service for interacting with receipt database
class ReceiptRepository {
  //ReceiptRepository({required this.db});
  Database? db;

  static const _receiptsTableName = 'receipts';
  static const _receiptsPath = '/receipts';

  /// Saves a receipt file of a Receipt
  ///
  /// Takes the [file] to be saved and the id of the receipt for which it
  /// belongs to.
  Future<void> _saveReceiptFile(XFile file, String fileName) async {
    final path = await getPath(_receiptsPath);
    await file.saveTo('$path/$fileName');
  }

  /// Deletes a receipts file with [fileName]
  Future<void> _deleteReceiptFile(String fileName) async {
    final path = await getPath(_receiptsPath);
    // TODO Handle errors
    await File('$path/$fileName').delete();
    return;
  }

  /// Gets all the receipts from the database
  Future<List<Receipt>> getReceipts() async {
    await _openDatabase();
    final data = await db!.query(_receiptsTableName);
    final List<Receipt> receipts = [];

    for (var map in data) {
      receipts.add(Receipt.fromMap(map));
    }

    return receipts;
  }

  /// Adds a Receipt to the database
  Future<int> addReceipt(
      {required Receipt receipt, required XFile file}) async {
    await _saveReceiptFile(file, receipt.fileName);
    await _openDatabase();
    final result = await db!.insert(_receiptsTableName, receipt.toMap());
    return result;
  }

  /// Deletes a Receipt from the database
  Future<int> deleteReceipt(Receipt receipt) async {
    await _openDatabase();
    await _deleteReceiptFile(receipt.fileName);
    return db!.delete('receipts', where: 'id=?', whereArgs: [receipt.id]);
  }

  /// Returns the receipt file of a [receipt]
  Future<dynamic> getReceiptFile(String fileName) async {
    final path = await getPath(_receiptsPath);
    final file = XFile('$path/$fileName');
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

  /// Makes sure that the SQLite database is initialized and opened
  Future<void> _openDatabase() async {
    db ??= await initDb();
  }
}
