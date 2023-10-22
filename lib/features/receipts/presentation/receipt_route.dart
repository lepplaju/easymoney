import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../application/provider_receipts.dart';
import '../domain/receipt.dart';
import 'show_jpg_dialog.dart';
//import '../../../utils/show_pdf_dialog.dart';
import '../../snacks/snacks.dart';
import '../../../widgets/data_widget.dart';

/// Route for showing a single Receipt
///
/// Requires [receipt] to be shown
///
/// {@category Receipts}
class ReceiptRoute extends StatefulWidget {
  const ReceiptRoute({super.key, required this.receipt});
  final Receipt receipt;

  @override
  State<ReceiptRoute> createState() => _ReceiptRouteState();
}

/// State for [ReceiptRoute]
class _ReceiptRouteState extends State<ReceiptRoute> {
  late final ProviderReceipts providerReceipts;
  late final AppLocalizations locals;
  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerReceipts = Provider.of<ProviderReceipts>(context);
      locals = AppLocalizations.of(context)!;
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  /// Loads a receipt file of the Receipt
  ///
  /// Loads and pushes a dialog showing the loaded file
  _loadReceiptFile() async {
    try {
      final file = await providerReceipts.getReceiptImage(widget.receipt);
      switch (file.runtimeType) {
        // FIXME Figure out what this means
        case Image:
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowJpgDialog(
                  title: widget.receipt.fileName,
                  image: file,
                );
              },
            );
          }
          break;
        default:
          // TODO Support pdf files
          /*if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowPdfDialog(
                  title: widget.receipt.fileName,
                  pdf: file,
                );
              },
            );
          }*/
          break;
      }
    } catch (e) {
      // TODO Show error snackbar
      debugPrint(e.toString());
    }
  }

  /// Shows the description of the Receipt
  ///
  /// Requires [title] and [content] which will be scrollable if too long.
  Widget _description({required String title, required String content}) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 200),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Scrollbar(
              radius: const Radius.circular(5),
              thumbVisibility: false,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(content),
              )),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.receipt.dateOnly}: ${widget.receipt.store}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              DataWidget(title: locals.date, content: widget.receipt.dateOnly),
              DataWidget(
                  title: locals.amount, content: '${widget.receipt.euros}€'),
              DataWidget(title: locals.store, content: widget.receipt.store),
              _description(
                  title: locals.description,
                  content: widget.receipt.description),
              // FIXME Localization
              DataWidget(title: 'Minute', content: widget.receipt.minute),
              Text(
                locals.file,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadReceiptFile();
                  },
                  child: Text(widget.receipt.fileName),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  providerReceipts.deleteReceipt(widget.receipt).then((value) {
                    Navigator.of(context).pop();
                    sendSnack(
                      context: context,
                      content: locals.receiptRouteDeleteSuccessSnack,
                    );
                  }).catchError((e) {
                    sendSnack(
                      context: context,
                      content: locals.receiptRouteDeleteErrorSnack,
                    );
                  });
                },
                child: Text(locals.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
