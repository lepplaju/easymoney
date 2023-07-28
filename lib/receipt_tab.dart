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
    return ListView.builder(
      itemCount: providerReceipts.receipts.length,
      itemBuilder: receiptBuilder,
    );
  }
}
