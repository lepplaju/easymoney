import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../utils/create_route.dart';
import '../application/provider_invoices.dart';
import '../domain/invoice.dart';
import './invoice_route.dart';

/// Card to show invoice as a list item
///
/// Requires [invoice] to that will be shown.
///
/// {@category Invoices}
class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    final providerInvoices = Provider.of<ProviderInvoices>(context);
    final textTheme = Theme.of(context).textTheme;

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

    return InkWell(
      onTap: () {
        Navigator.of(context).push(createRoute(InvoiceRoute(
          invoice: invoice,
        )));
      },
      child: Container(
        height: 78,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.dateOnly,
                      style: textTheme.headlineSmall,
                    ),
                    Text(
                      invoice.target,
                      style: textTheme.headlineMedium,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              thickness: 1,
              indent: 8,
              width: 1,
            ),
            InkWell(
              onTap: () {
                providerInvoices.changeStatus(
                  id: invoice.id,
                  status: invoice.nextStatus(),
                );
              },
              child: Container(
                height: double.infinity,
                color: statusColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${invoice.euros}€',
                          style: textTheme.headlineSmall,
                        ),
                        Text(
                          statusText,
                          style: textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
