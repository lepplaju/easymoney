import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';

import '../../../utils/show_pdf_dialog.dart';
import '../../snacks/snacks.dart';
import '../application/provider_receipts.dart';
import '../domain/receipt.dart';
import 'pic_or_pdf_dialog.dart';
import 'show_jpg_dialog.dart';

/// Route for adding a new receipt
///
/// Requires [profileId] of the profile for whom the receipt will be
/// added.
///
/// {@category Receipts}
class AddReceiptRoute extends StatefulWidget {
  const AddReceiptRoute({super.key, required this.profileId});
  final int profileId;

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

  /// Loads a receipt file of the Receipt
  ///
  /// Loads and pushes a dialog showing the loaded file
  _loadReceiptFile() async {
    try {
      switch (file!.name.substring(file!.name.lastIndexOf('.'))) {
        case '.jpg':
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowJpgDialog(
                  // FIXME Localization
                  title: 'Preview',
                  image: Image.file(File(file!.path)),
                );
              },
            );
          }
          break;
        case '.pdf':
          final pdfFile = await PdfDocument.openFile(file!.path);
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowPdfDialog(
                  // FIXME Localization
                  title: 'Preview',
                  pdf: pdfFile,
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

  /// Creates a new Receipt
  ///
  /// Returns a [Receipt] as a future
  Future<Receipt> _createReceipt() async {
    late final double amount;
    if (amountTextController.text.isEmpty) {
      amount = 0;
    } else {
      try {
        amount = double.parse(amountTextController.text.trim());
      } catch (e) {
        // TODO Handle error
        return Future.error(e);
      }
    }
    try {
      final result = await providerReceipts.addReceipt(
        date: selectedDate ?? currentDate,
        amount: amount,
        store: storeTextController.text.trim(),
        description: descriptionTextController.text.trim(),
        file: file!,
        profileId: widget.profileId,
      );
      if (context.mounted) {
        // FIXME Localization
        sendSnack(context: context, content: 'Receipt created!');
      }
      return result;
    } catch (e) {
      // TODO Handle errors
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // FIXME Localization
        title: const Text('Add Receipt'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FIXME Localization
              Column(
                children: [
                  Text(
                    'Date of the receipt',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: selectedDate == null
                        ? Text(
                            '${currentDate.day}.${currentDate.month}.${currentDate.year}',
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        : Text(
                            '${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                            context: context,
                            initialDate: currentDate,
                            firstDate: currentDate
                                .subtract(const Duration(days: 1095)),
                            lastDate: currentDate);
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      // FIXME Localization
                      child: const Text('Edit')),
                  TextField(
                    controller: storeTextController,
                    decoration: const InputDecoration(
                      // FIXME Localization
                      label: Text('Store'),
                    ),
                    maxLength: 40,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    controller: descriptionTextController,
                    decoration: const InputDecoration(
                      // FIXME Localization
                      label: Text('Description'),
                    ),
                    maxLines: 5,
                    minLines: 1,
                    maxLength: 250,
                    textInputAction: TextInputAction.newline,
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        int newLines = newValue.text.split('\n').length;
                        if (newLines > 20) {
                          return oldValue;
                        } else {
                          return newValue;
                        }
                      }),
                    ],
                  ),
                  TextField(
                    controller: amountTextController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: const InputDecoration(
                      // FIXME Localization
                      label: Text('Amount'),
                      suffixIcon: Icon(Icons.euro),
                    ),
                    maxLength: 7,
                    textInputAction: TextInputAction.done,
                  ),
                  // FIXME Localization
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Receipt',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  // FIXME Localization
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Upload a picture/pdf of the receipt.'),
                  ),
                  // TODO Show the receipt file
                  if (file != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          _loadReceiptFile();
                        },
                        child: Text(file!.name.length > 15
                            ? '...${file!.name.substring(file!.name.lastIndexOf('.') - 15)}'
                            : file!.name),
                      ),
                    ),
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
                          final result = await picker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            file = result;
                          });
                          break;
                        case UploadType.picture:
                          final result = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() async {
                            file = result;
                          });
                          // TODO Throw error for incorrect filetype
                          break;
                        // TODO Add support for pdf
                        /*case UploadType.pdf:
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            // TODO Throw error if not pdf
                            setState(() {
                              file = XFile(result.files.single.path!);
                            });
                          }
                          break;*/
                        default:
                          break;
                      }
                    },
                    // FIXME Localization
                    child: Text(file == null ? 'Add' : 'Change'),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
