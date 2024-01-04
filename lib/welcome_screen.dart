import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './utils/create_route.dart';
import './features/profile/presentation/add_profile_route.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(createRoute(const AddProfileRoute()));
        },
        child: Text(locals.addProfile),
      ),
    );
  }
}
