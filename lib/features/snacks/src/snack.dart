import 'package:flutter/material.dart';

/// Snack to show as a notification
///
/// Takes [content] that will be shown in the notification
///
/// {@nodoc}
class Snack extends StatelessWidget {
  const Snack({super.key, required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Center(child: Text(content)),
    );
  }
}
