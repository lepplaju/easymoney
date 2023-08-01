import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import './providers/provider_receipts.dart';

import './theme.dart';
import './home_page.dart';
import './database/database.dart';

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
  void initState() {
    db = initDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
        future: db,
        builder: (BuildContext context, AsyncSnapshot<Database> snapshot) {
          if (!snapshot.hasData) {
            // TODO Splash screen
            return MaterialApp(
              home: Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.pink,
                  child: const Center(
                    child: Text(
                      'EasyMoney',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => ProviderReceipts(db: snapshot.data!)),
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
        });
  }
}
