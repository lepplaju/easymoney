import 'package:flutter/material.dart';

import '../../../utils/create_route.dart';
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
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        // TODO Open invoice route
        Navigator.of(context).push(createRoute(InvoiceRoute(
          invoice: invoice,
        )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
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
                  Text(
                    '${invoice.euros}€',
                    style: textTheme.headlineSmall,
                  )
                ],
              ),
              //Text(receipt.description)
            ],
          ),
        ),
      ),
    );
  }
}
