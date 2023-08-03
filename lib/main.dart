import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'features/receipts/application/provider_receipts.dart';

import 'theme.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<Database> db;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderReceipts()),
      ],
      child: MaterialApp(
        // Removes the debug banner in debug mode
        debugShowCheckedModeBanner: false,
        theme: MyTheme.light,
        routes: {
          '/': (context) => const HomePage(),
        },
      ),
    );
  }
}
