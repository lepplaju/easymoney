import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../application/provider_invoices.dart';
import './invoice_card.dart';

class InvoicesTab extends StatefulWidget {
  const InvoicesTab({super.key});

  @override
  State<InvoicesTab> createState() => _InvoicesTabState();
}

class _InvoicesTabState extends State<InvoicesTab> {
  late final ProviderInvoices providerInvoices;

  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerInvoices = Provider.of<ProviderInvoices>(context);
      providerInvoices.getInvoices();
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  Widget invoiceBuilder(BuildContext context, int index) {
    if (index == providerInvoices.invoices.length) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InvoiceCard(
        invoice: providerInvoices.invoices[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: invoiceBuilder,
      itemCount: providerInvoices.invoices.length + 1,
    );
  }
}
