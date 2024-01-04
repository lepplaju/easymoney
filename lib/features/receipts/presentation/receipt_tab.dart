import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'add_receipt_route.dart';
import 'receipt_card.dart';
import 'receipt_route.dart';

import '../application/provider_receipts.dart';
import '../../invoices/application/provider_invoices.dart';
import '../../profile/application/provider_profiles.dart';
import '../../snacks/snacks.dart';
import '../../../utils/create_route.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../welcome_screen.dart';

/// Tab for Receipts in the HomePage
///
/// Shows all the receipts for the selected profile.
class ReceiptTab extends StatefulWidget {
  const ReceiptTab({super.key});

  @override
  State<ReceiptTab> createState() => _ReceiptTabState();
}

/// State for [ReceiptTab]
class _ReceiptTabState extends State<ReceiptTab> {
  late final ProviderReceipts providerReceipts;
  late final ProviderProfiles providerProfiles;
  late final ProviderInvoices providerInvoices;
  late final AppLocalizations locals;

  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      providerInvoices = Provider.of<ProviderInvoices>(context);
      providerReceipts = Provider.of<ProviderReceipts>(context);
      providerReceipts.fetchReceipts(
          profileId: providerProfiles.selectedProfile?.id);
      locals = AppLocalizations.of(context)!;
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  /// Builds a list item from list of receipts
  ///
  /// Takes [context] and the [index] for the item.
  Widget receiptBuilder(BuildContext context, int index) {
    if (index == providerReceipts.receipts.length) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ReceiptCard(receipt: providerReceipts.receipts[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (providerProfiles.profiles.isEmpty) {
      return const WelcomeScreen();
    }
    return Stack(
      children: [
        ListView.builder(
          itemCount: providerReceipts.receipts.length + 1,
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
                  onPressed: () async {
                    if (providerProfiles.selectedProfile == null) return;
                    final confirmation = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmDialog(
                            child: Column(
                              children: [
                                Text(
                                  locals.receiptTabConfirmInvoice,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  locals.receiptTabConfirmDescription,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        });
                    if (confirmation == null) return;
                    if (!confirmation) return;
                    try {
                      await providerInvoices.createInvoice(
                        profile: providerProfiles.selectedProfile!,
                        receipts: providerReceipts.receipts,
                        files: await providerReceipts.getReceiptFiles(),
                      );
                      // FIXME Uncomment
                      //await providerReceipts.deleteAllReceipts();
                      if (context.mounted) {
                        DefaultTabController.of(context).animateTo(1);
                        sendSnack(
                          context: context,
                          content: locals.receiptTabInvoiceSuccessSanck,
                        );
                      }
                    } catch (e) {
                      // FIXME Log
                      debugPrint(e.toString());
                    }
                  },
                ),
              ),
              FloatingActionButton.extended(
                heroTag: 'addReceipt',
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  if (providerProfiles.selectedProfile != null) {
                    Navigator.of(context)
                        .push(
                      createRoute(
                        AddReceiptRoute(
                          profileId: providerProfiles.selectedProfile!.id,
                        ),
                      ),
                    )
                        .then((receipt) {
                      if (receipt != null) {
                        Navigator.of(context).push(createRoute(
                          ReceiptRoute(
                            receipt: receipt,
                          ),
                        ));
                      }
                    });
                  }
                },
                label: Text(locals.receiptTabAddReceiptButton),
              )
            ],
          ),
        ),
      ],
    );
  }
}
