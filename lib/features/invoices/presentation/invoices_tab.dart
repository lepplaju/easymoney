import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../application/provider_invoices.dart';
import '../../profile/application/provider_profiles.dart';
import './invoice_card.dart';
import '../../../welcome_screen.dart';

/// Tab for listing all of the invoices of the selected profile.
///
/// {@category Invoices}
class InvoicesTab extends StatefulWidget {
  const InvoicesTab({super.key});

  @override
  State<InvoicesTab> createState() => _InvoicesTabState();
}

/// State for the [InvoicesTab]
class _InvoicesTabState extends State<InvoicesTab> {
  late final ProviderInvoices providerInvoices;
  late final ProviderProfiles providerProfiles;

  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      providerInvoices = Provider.of<ProviderInvoices>(context);
      providerInvoices.getInvoices(providerProfiles.selectedProfile?.id);
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  /// Builds a Invoice Card
  ///
  /// Requires BuildContext [context] and [index] of the item.
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
    if (providerProfiles.profiles.isEmpty) {
      return const WelcomeScreen();
    }
    return ListView.builder(
      itemBuilder: invoiceBuilder,
      itemCount: providerInvoices.invoices.length + 1,
    );
  }
}
