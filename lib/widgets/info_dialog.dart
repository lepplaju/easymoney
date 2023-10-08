import 'package:flutter/material.dart';

import './dialog_components/dialog_titlebar.dart';

/// Dialog for choosing which type of file user is adding.
class InfoDialg extends StatelessWidget {
  const InfoDialg({super.key, this.title = 'Pssst!', required this.child});
  final String title;
  final Widget child;

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
              DialogTitleBar(title: title),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok'),
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
