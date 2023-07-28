import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/provider_receipts.dart';

import './theme.dart';
import './home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
