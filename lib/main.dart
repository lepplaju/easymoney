import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/receipts/application/provider_receipts.dart';
import 'features/profile/application/provider_profiles.dart';
import 'features/invoices/application/provider_invoices.dart';

import 'theme.dart';
import 'home_page.dart';

/// Entry point of the program
/// {@nodoc}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EasyMoney());
}

/// EasyMoney apps main widget
///
/// {@nodoc}
class EasyMoney extends StatefulWidget {
  const EasyMoney({super.key});

  @override
  State<EasyMoney> createState() => _EasyMoneyState();
}

/// State for [EasyMoney]
class _EasyMoneyState extends State<EasyMoney> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderReceipts()),
        ChangeNotifierProvider(create: (context) => ProviderProfiles()),
        ChangeNotifierProvider(create: (context) => ProviderInvoices()),
      ],
      child: MaterialApp(
        // Removes the debug banner in debug mode
        debugShowCheckedModeBanner: false,
        theme: EasyMoneyTheme.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fi', ''),
        ],
        routes: {
          '/': (context) => const HomePage(),
        },
      ),
    );
  }
}
