import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:pdf_render/pdf_render.dart';

import '../domain/receipt.dart';
import '../../../utils/database.dart';
import '../../../utils/file_operations.dart';

/// Service for interacting with receipt database
///
/// {@category Receipts}
class ReceiptRepository {
  Database? db;

  static const _receiptsTableName = 'receipts';
  static const _receiptsPath = '/receipts';

  /// Saves a receipt file of a Receipt
  ///
  /// Takes the [file] to be saved and the [fileName] to be used.
  Future<void> _saveReceiptFile(XFile file, String fileName) async {
    final path = await getPath(_receiptsPath);
    await file.saveTo('$path/$fileName');
  }

  /// Deletes a receipts file with [fileName]
  Future<void> _deleteReceiptFile(String fileName) async {
    final path = await getPath(_receiptsPath);
    await File('$path/$fileName').delete();
    return;
  }

  /// Gets all the receipts from the database
  ///
  /// Requires [profileId] of the profile whose receipts will be fetched.
  Future<List<Receipt>> getReceipts(int profileId) async {
    await _openDatabase();
    final data = await db!.query(
      _receiptsTableName,
      where: 'profileId = ?',
      whereArgs: [profileId],
    );
    final List<Receipt> receipts = [];

    for (var map in data) {
      receipts.add(Receipt.fromMap(map));
    }

    return receipts;
  }

  /// Adds a Receipt to the database
  ///
  /// Requires [receipt] to be added and [file] to be saved.
  Future<int> addReceipt(
      {required Receipt receipt, required XFile file}) async {
    await _saveReceiptFile(file, receipt.fileName);
    await _openDatabase();
    final result = await db!.insert(_receiptsTableName, receipt.toMap());
    return result;
  }

  /// Deletes a Receipt from the database
  ///
  /// Requires the [receipt] which will be removed
  Future<int> deleteReceipt(Receipt receipt) async {
    await _openDatabase();
    await _deleteReceiptFile(receipt.fileName);
    return db!.delete('receipts', where: 'id=?', whereArgs: [receipt.id]);
  }

  /// Returns the receipt file
  ///
  /// Requires [fileName] which will be loaded.
  Future<dynamic> getReceiptImage(String fileName) async {
    final path = await getPath(_receiptsPath);
    final file = XFile('$path/$fileName');
    try {
      final fileType = file.name.substring(file.name.lastIndexOf('.'));
      switch (fileType) {
        case '.jpg' || '.png':
          Image image = Image.file(File(file.path));
          return image;
        // TODO Support pdf files
        /*case '.pdf':
          PdfDocument doc = await PdfDocument.openFile(file.path);
          return doc;*/
        default:
          return Future.error(Exception('Incorrect filetype \'$fileType\''));
      }
    } catch (e) {
      // TODO Log
      debugPrint(e.toString());
      return Future.error(e);
    }
  }

  /// Gets a file for Receipt by [fileName]
  Future<File> getReceiptFile(String fileName) async {
    final path = await getPath(_receiptsPath);
    try {
      return File('$path/$fileName');
    } catch (e) {
      // FIXME Log
      debugPrint(e.toString());
      return Future.error('Error while trying to load receipt file');
    }
  }

  /// Makes sure that the SQLite database is initialized and opened
  Future<void> _openDatabase() async {
    db ??= await initDb();
  }
}
