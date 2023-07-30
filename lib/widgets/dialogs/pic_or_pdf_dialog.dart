import 'package:flutter/material.dart';

import './dialog_components/dialog_titlebar.dart';

enum UploadType { camera, picture, pdf }

/// Dialog for choosing which type of file user is adding.
class PicOrPdfDialog extends StatelessWidget {
  const PicOrPdfDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.3;
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
              const DialogTitleBar(title: 'Add a picture or pdf'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, UploadType.camera);
                },
                child: SizedBox(
                  width: buttonWidth,
                  child: const Text(
                    // FIXME Localization
                    'Take Picture',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, UploadType.picture);
                },
                child: SizedBox(
                  width: buttonWidth,
                  child: const Text(
                    // FIXME Localization
                    'Choose Picture',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, UploadType.pdf);
                },
                child: SizedBox(
                  width: buttonWidth,
                  child: const Text(
                    // FIXME Localization
                    'PDF',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
