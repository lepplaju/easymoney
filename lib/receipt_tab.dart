import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/provider_receipts.dart';

import './widgets/receipt_card.dart';
import './add_receipt_route.dart';
import '../receipt_route.dart';

/// Tab for Receipts in the HomePage
class ReceiptTab extends StatefulWidget {
  const ReceiptTab({super.key});

  @override
  State<ReceiptTab> createState() => _ReceiptTabState();
}

/// State for [ReceiptTab]
class _ReceiptTabState extends State<ReceiptTab> {
  late final ProviderReceipts providerReceipts;

  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerReceipts = Provider.of<ProviderReceipts>(context);
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  /// Builds a list item from list of receipts
  Widget receiptBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ReceiptCard(receipt: providerReceipts.receipts[index]),
    );
  }

  /// Creates a Widget [route] to be pushed
  PageRouteBuilder _createRoute(Widget route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
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
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: providerReceipts.receipts.length,
          itemBuilder: receiptBuilder,
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FloatingActionButton.small(
                  heroTag: 'composeInvoice',
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded),
                  onPressed: () {
                    // TODO Compose the invoice
                  },
                ),
              ),
              FloatingActionButton.extended(
                heroTag: 'addReceipt',
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(_createRoute(const AddReceiptRoute()))
                      .then((receipt) {
                    if (receipt != null) {
                      Navigator.of(context).push(_createRoute(
                        ReceiptRoute(
                          receipt: receipt,
                        ),
                      ));
                    }
                  });
                },
                // FIXME Localization
                label: const Text('Add Receipt'),
              )
            ],
          ),
        ),
      ],
    );
  }
}
