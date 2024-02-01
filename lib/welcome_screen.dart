import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import './utils/create_route.dart';
import './features/profile/presentation/add_profile_route.dart';
import 'features/profile/application/provider_profiles.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final providerProfiles = Provider.of<ProviderProfiles>(context);
    final locals = AppLocalizations.of(context)!;
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(createRoute(const AddProfileRoute()));
          },
          child: Text(locals.addProfile),
        ),
        InkWell(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                locals.continueWithoutAccount,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            onTap: () {
              providerProfiles.addTempProfile();
            }),
      ],
    );
  }
}
