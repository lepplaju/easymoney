import 'package:flutter/material.dart';

import '../../../widgets/dialog_components/dialog_titlebar.dart';

enum UploadType { camera, picture }

/// Dialog for choosing which type of file user is adding.
///
/// {@category Receipts}
class PicOrPdfDialog extends StatelessWidget {
  const PicOrPdfDialog({super.key});
  final verticalPadding = 10.0;

  /// Builds a button widget for the options
  ///
  /// Requires [text] and a void function [onPressed]
  Widget _button({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: verticalPadding),
      child: ElevatedButton(
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          insetPadding: const EdgeInsets.all(20),
          //backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // FIXME Localization
              const DialogTitleBar(title: 'Add a picture'),
              SizedBox(height: verticalPadding),
              _button(
                // FIXME Localization
                text: 'Take Picture',
                onPressed: () => Navigator.pop(context, UploadType.camera),
              ),
              _button(
                // FIXME Localization
                text: 'Choose Picture',
                onPressed: () => Navigator.pop(context, UploadType.picture),
              ),
              // TODO Add support for pdf
              /*_button(
                text: 'PDF',
                onPressed: () => Navigator.pop(context, UploadType.pdf),
              ),*/
              SizedBox(height: verticalPadding),
            ],
          ),
        ),
      ),
    );
  }
}
