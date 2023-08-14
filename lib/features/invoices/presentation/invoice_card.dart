import 'package:flutter/material.dart';

import '../../../utils/create_route.dart';

//import 'receipt_route.dart';
import '../domain/invoice.dart';
import './invoice_route.dart';

/// Card to show receipt info in the receipt list
///
/// Requires [receipt] to be shown.
class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  const InvoiceCard({super.key, required this.invoice});

  /// Creates a ReceiptRoute route
  /*PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ReceiptRoute(
        receipt: receipt,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }*/

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
