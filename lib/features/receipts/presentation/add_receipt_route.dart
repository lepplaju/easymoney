import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';

import '../../../utils/show_pdf_dialog.dart';
import '../../../utils/file_operations.dart';
import '../../../widgets/info_dialog.dart';
import '../../snacks/snacks.dart';
import '../application/provider_receipts.dart';
import '../domain/receipt.dart';
import 'pic_or_pdf_dialog.dart';
import 'show_image_dialog.dart';

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
  final minuteTextController = TextEditingController();
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
    minuteTextController.dispose();
    super.dispose();
  }

  /// Loads a receipt file of the Receipt
  ///
  /// Loads and pushes a dialog showing the loaded file
  _loadReceiptFile({required AppLocalizations locals}) async {
    try {
      switch (file!.name.substring(file!.name.lastIndexOf('.'))) {
        case '.jpg':
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowImageDialog(
                  title: locals.addReceiptRouteFilePreview,
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
                  title: locals.addReceiptRouteFilePreview,
                  pdf: pdfFile,
                );
              },
            );
          }
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Creates a new Receipt
  ///
  /// Returns a [Receipt] as a future
  Future<Receipt> _createReceipt({required AppLocalizations locals}) async {
    if (storeTextController.text.trim().isEmpty ||
        amountTextController.text.trim().isEmpty ||
        minuteTextController.text.trim().isEmpty ||
        file == null) {
      late final String message;
      if (storeTextController.text.trim().isEmpty) {
        message = locals.addReceiptRouteInvalidStore;
      } else if (amountTextController.text.trim().isEmpty) {
        message = locals.addReceiptRouteInvalidAmount;
      } else if (minuteTextController.text.trim().isEmpty) {
        message = locals.addReceiptRouteInvalidMinute;
      } else {
        message = locals.addReceiptRouteInvalidPicture;
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return InfoDialg(
              child: Text(message),
            );
          });
      return Future.error('validation-error');
    }
    late final double amount;
    if (amountTextController.text.isEmpty) {
      amount = 0;
    } else {
      try {
        amount = double.parse(amountTextController.text.trim());
      } catch (e) {
        return Future.error(e);
      }
    }
    try {
      final result = await providerReceipts.addReceipt(
        date: selectedDate ?? currentDate,
        amount: amount,
        store: storeTextController.text.trim(),
        description: descriptionTextController.text.trim(),
        minute: minuteTextController.text.trim(),
        file: file!,
        profileId: widget.profileId,
      );
      if (context.mounted) {
        sendSnack(
            context: context, content: locals.addReceiptRouteCreatedSnack);
      }
      return result;
    } catch (e) {
      if (context.mounted) {
        sendSnack(context: context, content: 'Oops, something went wrong...');
      }
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(locals!.addReceiptRouteTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    locals.addReceiptRouteDate,
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
                      child: Text(locals.edit)),

                  // Store
                  TextField(
                    controller: storeTextController,
                    decoration: InputDecoration(
                      label: Text(locals.store),
                      hintText: 'Prisma, Lidl...',
                    ),
                    maxLength: 40,
                    textInputAction: TextInputAction.next,
                  ),

                  // Description
                  TextField(
                    controller: descriptionTextController,
                    decoration: InputDecoration(
                      label: Text(locals.description),
                      hintText: 'Grillijuhliin, Halloween etc...',
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
                    decoration: InputDecoration(
                      label: Text(locals.amount),
                      suffixIcon: const Icon(Icons.euro),
                    ),
                    maxLength: 7,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    controller: minuteTextController,
                    decoration: InputDecoration(
                      label: Text(locals.minute),
                      hintText: 'Kokous 1/23, Meeting 1/23...',
                    ),
                    maxLength: 20,
                    textInputAction: TextInputAction.done,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      locals.addReceiptRouteReceipt,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(locals.addReceiptRouteUploadHelp),
                  ),
                  if (file != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          _loadReceiptFile(locals: locals);
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
                          setState(() {
                            file = result;
                          });
                          // TODO Support for HEIC so apple users can be happy
                          if (isAcceptedType(
                              Receipt.acceptedFileTypes, file!.name)) {
                            break;
                          }
                          throw Exception('incorrect-filetype');
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
                    child: Text(file == null ? locals.add : locals.change),
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
                      // Cancel button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(locals.cancel),
                      ),

                      // Save button
                      ElevatedButton(
                        onPressed: () async {
                          final receipt = await _createReceipt(locals: locals);
                          if (context.mounted) {
                            Navigator.of(context).pop(receipt);
                          }
                        },
                        child: Text(locals.save),
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
