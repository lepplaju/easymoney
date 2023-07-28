import 'package:flutter/material.dart';

import './receipt_tab.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EasyMoney'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                // FIXME Localization
                text: 'Receipts',
              ),
              Tab(
                // FIXME Localization
                text: 'Invoices',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReceiptTab(),
            // TODO Invoices
            Placeholder(),
          ],
        ),
      ),
    );
  }
}
