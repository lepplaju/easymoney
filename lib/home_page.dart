import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

import 'features/profile/application/provider_profiles.dart';
import 'features/receipts/presentation/receipt_tab.dart';
import 'features/profile/presentation/app_bar_button_profiles.dart';
import 'features/profile/presentation/add_profile_route.dart';

import 'utils/create_route.dart';

/// Route for the home screen
class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for [HomePage]
class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  late final ProviderProfiles providerProfiles;

  Future<void>? future;
  var isInitialized = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    future = providerProfiles.getProfiles().then((value) {}).catchError((e) {
      // FIXME Log
      print(e);
      Navigator.of(context).push(
        createRoute(
          const AddProfileRoute(
            allowReturn: false,
          ),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      //future = providerProfiles.getProfiles();
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EasyMoney'),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AppBarButtonProfiles(),
            ),
          ],
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
        body: FutureBuilder(
            future: future,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const TabBarView(
                  children: [
                    ReceiptTab(),
                    // TODO Invoices
                    Placeholder(),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
