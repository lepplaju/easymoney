import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../application/provider_profiles.dart';
import '../domain/profile.dart';
import '../presentation/add_profile_route.dart';
import '../../../utils/create_route.dart';
import '../../receipts/application/provider_receipts.dart';

/// DropdownMenu for profile actions
class AppBarButtonProfiles extends StatelessWidget {
  const AppBarButtonProfiles({
    super.key,
  });

  List<DropdownMenuItem<int>> _items(
      BuildContext context, List<Profile> profiles, AppLocalizations locals) {
    final List<DropdownMenuItem<int>> items = [];
    for (var profile in profiles) {
      items.add(DropdownMenuItem(
        value: profile.id,
        child: Text(
          profile.profileName,
          style: Theme.of(context).dropdownMenuTheme.textStyle,
        ),
      ));
    }
    items.add(DropdownMenuItem<int>(
        value: 0,
        child: Text(
          locals.appBarButtonEditProfile,
          style: const TextStyle(color: Colors.black),
        )));
    items.add(DropdownMenuItem<int>(
        value: 1,
        child: Text(
          locals.appBarButtonAddProfile,
          style: const TextStyle(color: Colors.black),
        )));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final ProviderProfiles providerProfiles =
        Provider.of<ProviderProfiles>(context);
    final ProviderReceipts providerReceipts =
        Provider.of<ProviderReceipts>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<int>(
        selectedItemBuilder: (context) {
          return providerProfiles.profiles.map((profile) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Text(
                  profile.profileName,
                  style: const TextStyle(color: Colors.white),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
            );
          }).toList();
        },
        value: providerProfiles.selectedProfile?.id,
        onChanged: (value) {
          if (value == 0) {
            // TODO
          } else if (value == 1) {
            Navigator.of(context).push(createRoute(const AddProfileRoute()));
          } else {
            providerProfiles.selectProfile(id: value!);
            providerReceipts.fetchReceipts(profileId: value);
          }
        },
        items: _items(
          context,
          providerProfiles.profiles,
          AppLocalizations.of(context)!,
        ),
        underline: const SizedBox(),
      ),
    );
  }
}
