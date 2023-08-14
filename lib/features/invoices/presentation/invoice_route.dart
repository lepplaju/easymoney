import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../application/provider_invoices.dart';
import '../domain/invoice.dart';
import '../../../utils/show_pdf_dialog.dart';
import '../../snacks/application/send_snack.dart';

class InvoiceRoute extends StatelessWidget {
  const InvoiceRoute({
    super.key,
    required this.invoice,
  });
  final Invoice invoice;

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
            // FIXME Localization
            const Text('Files'),
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
            ElevatedButton(
              onPressed: () async {
                Share.shareXFiles(
                  [await providerInvoices.getInvoiceXFile(invoice: invoice)],
                  subject: 'Kululasku, ${invoice.target}, ${invoice.dateOnly}',
                  text: 'Liitteenä kululasku hankituista tarvikkeista kohteelle'
                      ' ${invoice.target}.\n\n'
                      'Ystävällisin terveisin,\n'
                      // FIXME Use profile name
                      'FIXME Add name',
                );
              },
              // FIXME Localization
              child: const Text('Send Invoice'),
            ),
            ElevatedButton(
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
              child: const Text('Delete Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}
