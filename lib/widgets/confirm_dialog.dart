import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './dialog_components/dialog_titlebar.dart';

/// Dialog for choosing which type of file user is adding.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {super.key,
      this.title = 'Pssst!',
      required this.child,
      this.yesText,
      this.noText});
  final String title;
  final Widget child;
  final String? yesText;
  final String? noText;

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
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
              DialogTitleBar(title: title),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(noText ?? locals.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(yesText ?? locals.yes),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
