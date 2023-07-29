import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/provider_receipts.dart';

import './widgets/receipt_card.dart';

class ReceiptTab extends StatefulWidget {
  const ReceiptTab({super.key});

  @override
  State<ReceiptTab> createState() => _ReceiptTabState();
}

class _ReceiptTabState extends State<ReceiptTab> {
  late final ProviderReceipts providerReceipts;

  @override
  void didChangeDependencies() {
    providerReceipts = Provider.of<ProviderReceipts>(context);
    super.didChangeDependencies();
  }

  Widget receiptBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ReceiptCard(receipt: providerReceipts.receipts[index]),
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
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  // TODO Add receipt
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
