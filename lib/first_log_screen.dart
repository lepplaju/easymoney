import 'package:easymoney/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirstLogScreen extends StatefulWidget {
  const FirstLogScreen({Key? key}) : super(key: key);

  @override
  _FirstLogScreenState createState() => _FirstLogScreenState();

  static _FirstLogScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_FirstLogScreenState>();
}

class _FirstLogScreenState extends State<FirstLogScreen> {
  Locale _locale = const Locale("en", "");

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
      EasyMoney.of(context)!.setLocale(_locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(locals.welcomeToEasyMoney),
        Text(locals.choooseLanguageText), //Text("Choose your language: "),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => setLocale(Locale("fi", "")),
                child: Text("Finnish")),
            Padding(padding: EdgeInsets.all(8)),
            ElevatedButton(
                onPressed: () => setLocale(Locale("en", "")),
                child: Text("English"))
          ],
        )
      ]),
    );
  }
}
