import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_render/pdf_render.dart' as render;
import 'package:share_plus/share_plus.dart';

import '../../receipts/domain/receipt.dart';
import '../data/invoices_repository.dart';
import '../../profile/domain/profile.dart';
import '../domain/invoice.dart';
import '../../../utils/replace_nordics.dart';

/// Manages invoices
///
/// {@category Invoices}
class ProviderInvoices with ChangeNotifier {
  final InvoicesRepository _invoicesRepository = InvoicesRepository();

  final List<Invoice> _invoices = [];

  /// Returns the list of the invoices
  List<Invoice> get invoices {
    _invoices.sort((i1, i2) => i2.date.compareTo(i1.date));
    return _invoices;
  }

  /// Composes a pdf invoice from receipts
  ///
  /// Requires [profile] to whom the invoice is created,
  /// list of the [receipts] to be used and list of [files] which
  /// are the pictures of the receipts.
  Future<void> createInvoice({
    required Profile profile,
    required List<Receipt> receipts,
    required List<File> files,
  }) async {
    final receiptAndFileList = <Map<String, dynamic>>[];

    final footer = pw.Footer(
      trailing: pw.Text('Created using EasyMoney'),
    );

    for (var receipt in receipts) {
      final receiptMap = {
        'receipt': receipt,
        'file': files.firstWhere((e) => e.path.contains(receipt.fileName))
      };
      receiptAndFileList.add(receiptMap);
    }
    final pdf = pw.Document();
    final thinData = await rootBundle.load('assets/fonts/Roboto-Thin.ttf');
    final thinStyle = pw.TextStyle(font: pw.Font.ttf(thinData));
    final regularData =
        await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final regularStyle = pw.TextStyle(font: pw.Font.ttf(regularData));
    final boldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final boldStyle = pw.TextStyle(font: pw.Font.ttf(boldData));
    final date = DateTime.now();
    final dateOnly = '${date.day}.${date.month}.${date.year}';
    final receiptWidgets = <pw.Widget>[];
    // TODO Add receipt minutes to invoice pdf
    int endSum = 0;
    for (var receiptMap in receiptAndFileList) {
      final Receipt receipt = receiptMap['receipt'];
      endSum += receipt.amount;
      receiptWidgets.add(
        pw.Flexible(
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Receipt title
                  pw.Text(
                    '${receipt.dateOnly}, ${receipt.store}',
                    style: regularStyle,
                  ),
                  // Receipt description
                  pw.SizedBox(
                    width: 400,
                    child: pw.Text(
                      receipt.description,
                      softWrap: true,
                      style: thinStyle,
                    ),
                  ),
                  pw.Text(
                    'Pöytäkirja: ${receipt.minute}',
                    style: boldStyle.copyWith(fontSize: 10),
                  ),
                ],
              ),
              pw.Text('${receipt.euros}€', style: regularStyle),
            ],
          ),
        ),
      );
      receiptWidgets.add(pw.Divider());
    }
    var fileName = '${dateOnly}_${replaceNordics(text: profile.target)}';
    var fileCount = 0;
    var fileEnding = '';
    while (
        await _invoicesRepository.isFileNameTaken('$fileName$fileEnding.pdf')) {
      fileCount++;
      fileEnding = '_$fileCount';
    }
    fileName = '$fileName$fileEnding.pdf';

    final invoice = Invoice(
      id: DateTime.now().millisecondsSinceEpoch,
      profileId: profile.id,
      date: date,
      target: profile.target,
      name: '${profile.firstName} ${profile.lastName}',
      amount: endSum,
      fileName: fileName,
    );
    pdf.addPage(
      pw.MultiPage(
          footer: (_) => footer,
          maxPages: 30,
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.SizedBox(
                width: double.infinity,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 20),
                  child: pw.Text(
                    'Kululasku ${profile.target}, '
                    '$dateOnly,\n'
                    '${profile.firstName} ${profile.lastName}',
                    style: boldStyle.copyWith(
                      fontSize: 20,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
              //pw.Expanded(
              //child:
              pw.Wrap(
                //mainAxisAlignment: pw.MainAxisAlignment.start,
                //mainAxisSize: pw.MainAxisSize.min,
                children: receiptWidgets,
              ),
              //),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Yhteensä:', style: boldStyle),
                  pw.Text('${(endSum / 100).toStringAsFixed(2)}€',
                      style: boldStyle),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('Saaja:', style: boldStyle),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  '${profile.firstName} ${profile.lastName}',
                  style: boldStyle,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(profile.iban, style: boldStyle),
              ),
            ];
          }),
    );
    for (var receiptMap in receiptAndFileList) {
      File file = receiptMap['file'];
      Receipt receipt = receiptMap['receipt'];
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      '${receipt.store}, ${receipt.dateOnly}',
                      style: boldStyle.copyWith(fontSize: 20),
                    ),
                    pw.Image(
                      pw.MemoryImage(file.readAsBytesSync()),
                    ),
                  ],
                ),
                footer,
              ],
            );
          },
        ),
      );
    }
    await _invoicesRepository.saveInvoice(invoice: invoice, doc: pdf);
    notifyListeners();
  }

  /// Changes the status of the invoice
  ///
  /// Requires [id] of the invoice to be changed and the [status] which
  /// will be given to the invoice
  Future<void> changeStatus({
    required int id,
    required Status status,
  }) async {
    final data = {'status': status.name};
    await _invoicesRepository.changeStatus(id: id, data: data);
    final oldInvoice = _invoices.firstWhere((invoice) => invoice.id == id);
    _invoices.removeWhere((invoice) => invoice.id == id);
    _invoices.add(Invoice.fromMap(map: {
      ...oldInvoice.toMap(),
      'status': status.name,
    }));
    notifyListeners();
  }

  /// Deletes an invoice
  ///
  /// Requires [invoice] which will be deleted
  Future<void> deleteInvoice(Invoice invoice) async {
    _invoices.removeWhere((e) => e.id == invoice.id);
    await _invoicesRepository.deleteInvoice(invoice: invoice);
    notifyListeners();
  }

  /// Fetches all the invoices of a profile
  ///
  /// Requires [profileId] of the profile whose invoices are fetched.
  Future<void> getInvoices(int? profileId) async {
    if (profileId == null) return;
    _invoices.clear();
    _invoices.addAll(await _invoicesRepository.getInvoices(profileId));
    notifyListeners();
  }

  /// Returns a file of the invoice
  ///
  /// Requires [invoice] of whose file is returned.
  Future<render.PdfDocument> getInvoiceFile({required Invoice invoice}) async {
    return await _invoicesRepository.getInvoiceFile(fileName: invoice.fileName);
  }

  /// Returns a file of the invoice as XFile
  ///
  /// Requires [invoice] of whose file is returned.
  Future<XFile> getInvoiceXFile({required Invoice invoice}) async {
    return await _invoicesRepository.getInvoiceXFile(
        fileName: invoice.fileName);
  }
}
