import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'features/invoices/presentation/invoices_tab.dart';
import 'features/profile/application/provider_profiles.dart';
import 'features/profile/presentation/add_profile_route.dart';
import 'features/profile/presentation/app_bar_button_profiles.dart';
import 'features/receipts/presentation/receipt_tab.dart';

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
  late final AppLocalizations locals;

  Future<void>? future;
  var isInitialized = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    future = providerProfiles.getProfiles().then((value) {}).catchError((e) {
      // FIXME Log
      print(e);
      Navigator.of(context)
          .push(
            createRoute(
              const AddProfileRoute(
                allowReturn: false,
              ),
            ),
          )
          .then((value) => providerProfiles.getProfiles());
    });
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      locals = AppLocalizations.of(context)!;
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
          bottom: TabBar(
            tabs: [
              Tab(
                text: locals.homePageReceiptsTabLabel,
              ),
              Tab(
                text: locals.homePageInvoicesTabLabel,
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
                    InvoicesTab(),
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
