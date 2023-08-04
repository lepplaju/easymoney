import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

import 'features/profile/application/provider_profiles.dart';
import 'features/receipts/presentation/receipt_tab.dart';
import 'features/profile/presentation/app_bar_button_profiles.dart';
import 'features/profile/presentation/add_profile_route.dart';

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

  var isInitialized = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    providerProfiles.getProfiles().then((value) {
      if (providerProfiles.profiles.isEmpty) {
        Navigator.of(context).push(_createRoute(const AddProfileRoute()));
      }
    }).catchError((e) {
      Navigator.of(context).push(_createRoute(const AddProfileRoute()));
    });
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  /// Creates a Widget [route] to be pushed
  PageRouteBuilder _createRoute(Widget route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EasyMoney'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AppBarButtonProfiles(
                  firstName: 'Karel', lastName: 'Parkkola'),
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
