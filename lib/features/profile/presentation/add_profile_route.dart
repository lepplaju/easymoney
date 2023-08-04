import 'package:flutter/material.dart';

class AddProfileRoute extends StatefulWidget {
  const AddProfileRoute({super.key});

  @override
  State<AddProfileRoute> createState() => _AddProfileRouteState();
}

class _AddProfileRouteState extends State<AddProfileRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // FIXME Localization
        title: const Text('New Profile'),
        centerTitle: true,
      ),
      body: const Placeholder(),
    );
  }
}
