import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/provider_receipts.dart';
import './objects/receipt.dart';
import './widgets/dialogs/show_jpg_dialog.dart';
import './widgets/dialogs/show_pdf_dialog.dart';

/// Route for showing a Receipt
class ReceiptRoute extends StatefulWidget {
  const ReceiptRoute({super.key, required this.receipt});
  final Receipt receipt;

  @override
  State<ReceiptRoute> createState() => _ReceiptRouteState();
}

/// State for [ReceiptRoute]
class _ReceiptRouteState extends State<ReceiptRoute> {
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

  /// Loads a receipt file of the Receipt
  ///
  /// Loads and pushes a dialog showing the loaded file
  _loadReceiptFile() async {
    try {
      final file = await providerReceipts.getReceiptFile(widget.receipt);
      switch (file.runtimeType) {
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
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowPdfDialog(
                  title: widget.receipt.fileName,
                  pdf: file,
                );
              },
            );
          }
          break;
      }
    } catch (e) {
      // TODO Show error snackbar
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.receipt.dateOnly}: ${widget.receipt.store}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // FIXME Localization
          Text('Amount: ${widget.receipt.euros}€'),
          // FIXME Localization
          const Text('Files'),
          TextButton(
            onPressed: () async {
              _loadReceiptFile();
            },
            child: Text(widget.receipt.fileName),
          ),
        ],
      ),
    );
  }
}
