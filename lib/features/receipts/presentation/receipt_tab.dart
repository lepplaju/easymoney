import 'package:easymoney/features/snacks/application/send_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../application/provider_receipts.dart';
import '../../profile/application/provider_profiles.dart';
import '../../invoices/application/provider_invoices.dart';

import 'receipt_card.dart';
import 'add_receipt_route.dart';
import 'receipt_route.dart';

/// Tab for Receipts in the HomePage
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

  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      providerInvoices = Provider.of<ProviderInvoices>(context);
      providerReceipts = Provider.of<ProviderReceipts>(context);
      providerReceipts.fetchReceipts(
          profileId: providerProfiles.selectedProfile?.id);
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
                    // FIXME Catch null profile
                    // TODO Compose the invoice
                    try {
                      await providerInvoices.createInvoice(
                        profile: providerProfiles.selectedProfile!,
                        receipts: providerReceipts.receipts,
                        files: await providerReceipts.getReceiptFiles(),
                      );

                      if (context.mounted) {
                        DefaultTabController.of(context).animateTo(1);
                        sendSnack(
                          context: context,
                          // FIXME Localization
                          content: 'Invoice created!',
                        );
                      }
                    } catch (e) {
                      print(e);
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
                  Navigator.of(context)
                      .push(_createRoute(AddReceiptRoute(
                    // FIXME Catch error
                    profileId: providerProfiles.selectedProfile!.id,
                  )))
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
