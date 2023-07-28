import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [
        // TODO Add providers here
      ],
      child: MaterialApp(
        // Removes the debug banner in debug mode
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: MyTheme.light,
        // TODO Add home
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
