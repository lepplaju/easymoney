import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';

import '../objects/receipt.dart';

/// Manages receipts which are not part of any invoice
class ProviderReceipts with ChangeNotifier {
  final List<Receipt> _receipts = //[];
      // For testing
      [
    Receipt(
      id: '6124846546',
      date: DateTime(2023, 4, 24),
      amount: 3599,
      store: 'Prisma',
      description: 'Allasbileiden tarvikkeita',
      fileName: '',
    ),
    Receipt(
      id: '654856546',
      date: DateTime(2023, 4, 24),
      amount: 699,
      store: 'Mestarin Herkku',
      description: 'Unohtuneita tarvikkeita',
      fileName: '',
    ),
    Receipt(
      id: '654846566',
      date: DateTime(2023, 6, 12),
      amount: 19999,
      store: 'K-Market',
      description: 'Ben & Jerry',
      fileName: '',
    ),
    Receipt(
      id: '654816546',
      date: DateTime(2023, 7, 30),
      amount: 49999,
      store: 'Kuntokauppa',
      description: 'Rautaa salille',
      fileName: '',
    ),
  ];

  /// Returns a list of all the Receipts
  List<Receipt> get receipts {
    _receipts.sort((r1, r2) => r1.date.compareTo(r2.date));
    return _receipts;
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
    final id = DateTime.now().millisecondsSinceEpoch.toString();
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
  Future<String> saveReceiptFile(XFile file, String id) async {
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
