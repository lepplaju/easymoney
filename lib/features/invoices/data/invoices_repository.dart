import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pdf_render/pdf_render.dart' as render;
import 'package:pdf/widgets.dart' as pw;

import '../../../utils/database.dart';
import '../../../utils/file_operations.dart';
import '../domain/invoice.dart';

/// Service for interacting with invoice database
///
/// {@category Invoices}
class InvoicesRepository {
  Database? db;
  static const _invoicesPath = '/invoices';
  static const _invoicesTableName = 'invoices';

  /// Saves an invoice
  ///
  /// Requires the [invoice] that will be saved and pdf [doc] that
  /// is the invoice file.
  Future<void> saveInvoice({
    required Invoice invoice,
    required pw.Document doc,
  }) async {
    await _openDatabase();
    final path = await getPath(_invoicesPath);
    final file = File('$path/${invoice.fileName}');
    final savedDoc = await doc.save();
    await file.writeAsBytes(savedDoc);
    await db!.insert(_invoicesTableName, invoice.toMap());
  }

  /// Changes the invoice status
  ///
  /// Requires the [id] of the invoice to be changed and the [data] map
  /// containing status key with the status enum name.
  Future<void> changeStatus({
    required int id,
    required Map<String, String> data,
  }) async {
    await _openDatabase();
    await db!.update(
      _invoicesTableName,
      data,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  /// Deletes an [invoice]
  Future<void> deleteInvoice({required Invoice invoice}) async {
    final path = await getPath(_invoicesPath);
    try {
      await File('$path/${invoice.fileName}').delete();
    } catch (e) {
      // FIXME Log
      // FIXME Handle same file name
      debugPrint('Could not find file named ${invoice.fileName}');
    }
    await _openDatabase();
    await db!
        .delete(_invoicesTableName, where: 'id=?', whereArgs: [invoice.id]);
  }

  /// Returns all the invoices of a profile
  ///
  /// Requires [profileId] of the profile whose invoices will be fetched.
  Future<List<Invoice>> getInvoices(int profileId) async {
    await _openDatabase();
    final List<Invoice> invoices = [];
    final data = await db!.query(
      _invoicesTableName,
      where: 'profileId = ?',
      whereArgs: [profileId],
    );
    for (var map in data) {
      invoices.add(Invoice.fromMap(map: map));
    }
    return invoices;
  }

  /// Returns the pdf file of invoice
  ///
  /// Requires [fileName] of the invoice which will be fetched.
  Future<render.PdfDocument> getInvoiceFile({required String fileName}) async {
    final path = await getPath(_invoicesPath);
    final pdf = await render.PdfDocument.openFile('$path/$fileName');
    return pdf;
  }

  /// Retruns invoice file as XFile
  ///
  /// Requires [fileName] of the invoice which will be fetched.
  Future<XFile> getInvoiceXFile({required String fileName}) async {
    final path = await getPath(_invoicesPath);
    final file = XFile('$path/$fileName');
    return file;
  }

  /// Checks if the file name is already taken
  ///
  /// Requires [fileName] that will be checked
  ///
  /// Returns true if [fileName] exists and false if not.
  Future<bool> isFileNameTaken(String fileName) async {
    final path = await getPath(_invoicesPath);
    return await File('$path/$fileName').exists();
  }

  /// Makes sure that the SQLite database is initialized and opened
  Future<void> _openDatabase() async {
    db ??= await initDb();
  }
}
