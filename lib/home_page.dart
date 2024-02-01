import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:easymoney/first_log_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'features/receipts/application/provider_receipts.dart';
import 'features/invoices/presentation/invoices_tab.dart';
import 'features/profile/application/provider_profiles.dart';
import 'features/profile/presentation/add_profile_route.dart';
import 'features/profile/presentation/app_bar_button_profiles.dart';
import 'features/receipts/presentation/receipt_tab.dart';
import 'info_route.dart';
import 'welcome_screen.dart';

import 'utils/create_route.dart';

/// Route for the home screen
/// {@nodoc}
class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for [HomePage]
class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  late final ProviderProfiles providerProfiles;
  late final ProviderReceipts providerReceipts;
  late final AppLocalizations locals;

  Future<void>? future;
  int? loadedProfileId;
  var isInitialized = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    future = providerProfiles.getProfiles();
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      providerReceipts = Provider.of<ProviderReceipts>(context);
      locals = AppLocalizations.of(context)!;
      isInitialized = true;
    }
    if (loadedProfileId != providerProfiles.selectedProfile?.id) {
      loadedProfileId = providerProfiles.selectedProfile?.id;
      providerReceipts.fetchReceipts(
          profileId: providerProfiles.selectedProfile?.id);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: providerProfiles.profiles.isNotEmpty ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EasyMoney'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.of(context).push(createRoute(const InfoRoute()));
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: providerProfiles.profiles.isNotEmpty
                  ? const AppBarButtonProfiles()
                  : TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(createRoute(const AddProfileRoute()));
                      },
                      child: Text(
                        locals.addProfile,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
            ),
          ],
          bottom: TabBar(
            tabs: providerProfiles.profiles.isNotEmpty
                ? [
                    Tab(
                      text: locals.homePageReceiptsTabLabel,
                    ),
                    Tab(
                      text: locals.homePageInvoicesTabLabel,
                    ),
                  ]
                : [
                    Tab(
                      text: locals.welcome,
                    )
                  ],
          ),
        ),
        body: FutureBuilder(
            future: future,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TabBarView(
                  children: providerProfiles.profiles.isNotEmpty
                      ? [
                          ReceiptTab(profile: providerProfiles.selectedProfile),
                          const InvoicesTab(),
                        ]
                      : [
                          const Column(children: [
                            FirstLogScreen(),
                            Padding(padding: EdgeInsets.all(20)),
                            const WelcomeScreen(),
                          ])
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
