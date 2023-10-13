import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../application/provider_invoices.dart';
import '../domain/invoice.dart';
import '../../../widgets/data_widget.dart';
import '../../../utils/show_pdf_dialog.dart';
import '../../snacks/snacks.dart';

/// Route to show a single Invoice
///
/// Requires the [invoice] that will be shown.
///
/// {@category Invoices}
class InvoiceRoute extends StatelessWidget {
  const InvoiceRoute({
    super.key,
    required this.invoice,
  });
  final Invoice invoice;

  /// Button to be shown with different actions
  Widget _actionButton(
      {required VoidCallback onPressed, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onPressed,
        child: SizedBox(
          width: 80,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProviderInvoices providerInvoices =
        Provider.of<ProviderInvoices>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${invoice.dateOnly}: ${invoice.target}'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            DataWidget(
              // FIXME Localization
              title: 'Date:',
              content: invoice.dateOnly,
            ),
            DataWidget(
              // FIXME Localization
              title: 'Reference:',
              content: invoice.target,
            ),
            DataWidget(
              // FIXME Localization
              title: 'Invoicer:',
              content: invoice.name,
            ),
            DataWidget(
              // FIXME Localization
              title: 'Amount:',
              content: '${invoice.euros}€',
            ),
            Text(
              // FIXME Localization
              'File:',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            TextButton(
              onPressed: () async {
                final pdf =
                    await providerInvoices.getInvoiceFile(invoice: invoice);
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShowPdfDialog(
                        title: invoice.fileName,
                        pdf: pdf,
                      );
                    },
                  );
                }
              },
              child: Text(invoice.fileName),
            ),
            _actionButton(
                onPressed: () async {
                  Share.shareXFiles(
                    [await providerInvoices.getInvoiceXFile(invoice: invoice)],
                    subject:
                        'Kululasku, ${invoice.target}, ${invoice.dateOnly}',
                    text:
                        'Liitteenä kululasku hankituista tarvikkeista kohteelle'
                        ' ${invoice.target}.\n\n'
                        'Ystävällisin terveisin,\n'
                        '${invoice.name}',
                  );
                },
                // FIXME Localization
                text: 'Send'),
            _actionButton(
              onPressed: () {
                providerInvoices.deleteInvoice(invoice).then((value) {
                  Navigator.of(context).pop();
                  sendSnack(
                    context: context,
                    // FIXME Localization
                    content: 'Invoice was deleted',
                  );
                }).catchError((e) {
                  sendSnack(
                    context: context,
                    // FIXME Localization
                    content: 'Could not delete Invoice',
                  );
                });
              },
              // FIXME Localization
              text: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
