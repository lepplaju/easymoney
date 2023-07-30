import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import './providers/provider_receipts.dart';

import './widgets/dialogs/pic_or_pdf_dialog.dart';
import './objects/receipt.dart';

// TODO Add preview for file
/// Route for adding a new receipt
class AddReceiptRoute extends StatefulWidget {
  const AddReceiptRoute({super.key});

  @override
  State<AddReceiptRoute> createState() => _AddReceiptRouteState();
}

/// State for [AddReceiptRoute]
class _AddReceiptRouteState extends State<AddReceiptRoute> {
  late final ProviderReceipts providerReceipts;
  final storeTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final amountTextController = TextEditingController();
  late final DateTime currentDate;
  final ImagePicker picker = ImagePicker();

  DateTime? selectedDate;
  XFile? file;
  var isInitialized = false;

  @override
  void initState() {
    currentDate = DateUtils.dateOnly(DateTime.now());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerReceipts = Provider.of<ProviderReceipts>(context);
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    storeTextController.dispose();
    descriptionTextController.dispose();
    amountTextController.dispose();
    super.dispose();
  }

  /// Creates a new Receipt
  ///
  /// Returns a [Receipt] as a future
  Future<Receipt> _createReceipt() async {
    return await providerReceipts.addReceipt(
      date: selectedDate ?? currentDate,
      amount: amountTextController.text.trim().isEmpty
          ? 0.00
          : double.parse(amountTextController.text.trim()),
      store: storeTextController.text.trim(),
      description: descriptionTextController.text.trim(),
      file: file!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // FIXME Localization
        title: const Text('Add Receipt'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // FIXME Localization
          const Text('Date of the receipt'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectedDate == null
                  ? Text(
                      '${currentDate.day}.${currentDate.month}.${currentDate.year}')
                  : Text(
                      '${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}'),
              ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: currentDate,
                        firstDate:
                            currentDate.subtract(const Duration(days: 1095)),
                        lastDate: currentDate);
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  // FIXME Localization
                  child: const Text('Edit'))
            ],
          ),
          TextField(
            controller: storeTextController,
            decoration: const InputDecoration(
              // FIXME Localization
              label: Text('Store'),
            ),
          ),
          TextField(
            controller: descriptionTextController,
            decoration: const InputDecoration(
              // FIXME Localization
              label: Text('Description'),
            ),
          ),
          TextField(
            controller: amountTextController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              // FIXME Localization
              label: Text('Amount'),
              suffixIcon: Icon(Icons.euro),
            ),
          ),
          // FIXME Localization
          const Text('Receipt'),
          // FIXME Localization
          const Text('Upload a picture/pdf of the receipt.'),
          ElevatedButton(
            onPressed: () async {
              var takesPic = await showDialog<UploadType>(
                  context: context,
                  builder: (BuildContext context) {
                    return const PicOrPdfDialog();
                  });
              if (takesPic == null) return;
              switch (takesPic) {
                case UploadType.camera:
                  file = await picker.pickImage(source: ImageSource.camera);
                  break;
                case UploadType.picture:
                  file = await picker.pickImage(source: ImageSource.gallery);
                  // TODO Throw error for incorrect filetype
                  break;
                case UploadType.pdf:
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    file = XFile(result.files.single.path!);
                  }
                  break;
                default:
                  break;
              }
            },
            // FIXME Localization
            child: const Text('Add'),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                // FIXME Localization
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final receipt = await _createReceipt();
                  if (context.mounted) {
                    Navigator.of(context).pop(receipt);
                  }
                },
                // FIXME Localization
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
