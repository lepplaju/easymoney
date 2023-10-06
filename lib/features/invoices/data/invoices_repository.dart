import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pdf_render/pdf_render.dart' as render;
import 'package:pdf/widgets.dart' as pw;

import '../../../utils/database.dart';
import '../../../utils/file_operations.dart';
import '../domain/invoice.dart';

class InvoicesRepository {
  Database? db;
  static const _invoicesPath = '/invoices';
  static const _invoicesTableName = 'invoices';

  Future<void> saveInvoice({
    required Invoice invoice,
    required pw.Document doc,
  }) async {
    await _openDatabase();
    final path = await getPath(_invoicesPath);
    final file = File('$path/${invoice.fileName}');
    await file.writeAsBytes(await doc.save());
    await db!.insert(_invoicesTableName, invoice.toMap());
  }

  Future<void> deleteInvoice({required Invoice invoice}) async {
    final path = await getPath(_invoicesPath);
    // TODO Handle errors
    try {
      await File('$path/${invoice.fileName}').delete();
    } catch (e) {
      // FIXME Handle same file name
      debugPrint('Could not find file named ${invoice.fileName}');
    }
    await _openDatabase();
    await db!
        .delete(_invoicesTableName, where: 'id=?', whereArgs: [invoice.id]);
  }

  Future<List<Invoice>> getInvoices() async {
    await _openDatabase();
    final List<Invoice> invoices = [];
    final data = await db!.query(
      _invoicesTableName,
    );
    for (var map in data) {
      invoices.add(Invoice.fromMap(map: map));
    }
    return invoices;
  }

  Future<render.PdfDocument> getInvoiceFile({required String fileName}) async {
    final path = await getPath(_invoicesPath);
    final pdf = await render.PdfDocument.openFile('$path/$fileName');
    return pdf;
  }

  Future<XFile> getInvoiceXFile({required String fileName}) async {
    final path = await getPath(_invoicesPath);
    final file = await XFile('$path/$fileName');
    return file;
  }

  /// Makes sure that the SQLite database is initialized and opened
  Future<void> _openDatabase() async {
    db ??= await initDb();
  }
}
