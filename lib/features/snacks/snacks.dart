import 'package:flutter/material.dart';

import './src/snack.dart';

/// Sens a snackbar notification
///
/// Takes [context], message [content] and optional [action]
///
/// {@category Snacks}
void sendSnack({
  required BuildContext context,
  required String content,
  SnackBarAction? action,
  int duration = 6,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      backgroundColor: color,
      duration: Duration(seconds: duration),
      content: Snack(
        content: content,
      ),
      action: action,
    ),
  );
}
