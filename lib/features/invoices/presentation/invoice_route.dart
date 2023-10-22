import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final locals = AppLocalizations.of(context)!;
    late final String statusText;
    late final Color statusColor;
    switch (invoice.status.name) {
      case 'waiting':
        statusText = locals.waiting;
        statusColor = Colors.pink;
      case 'sent':
        statusText = locals.sent;
        statusColor = Colors.purple;
      case 'paid':
        statusText = locals.paid;
        statusColor = Colors.green;
      default:
        statusText = 'error';
        statusColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${invoice.dateOnly}: ${invoice.target}'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              color: statusColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    '${locals.status}: $statusText',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            DataWidget(
              title: locals.invoiceRouteDate,
              content: invoice.dateOnly,
            ),
            DataWidget(
              title: locals.invoiceRouteReference,
              content: invoice.target,
            ),
            DataWidget(
              title: locals.invoiceRouteInvoicer,
              content: invoice.name,
            ),
            DataWidget(
              title: locals.invoiceRouteAmount,
              content: '${invoice.euros}€',
            ),
            Text(
              locals.invoiceRouteFile,
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
                text: locals.invoiceRouteSend),
            _actionButton(
              onPressed: () {
                providerInvoices.deleteInvoice(invoice).then((value) {
                  Navigator.of(context).pop();
                  sendSnack(
                    context: context,
                    content: locals.invoiceRouteSnackDeleteSuccess,
                  );
                }).catchError((e) {
                  sendSnack(
                    context: context,
                    content: locals.invoiceRouteSnackDeleteError,
                  );
                });
              },
              text: locals.delete,
            ),
          ],
        ),
      ),
    );
  }
}
