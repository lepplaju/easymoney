import 'package:flutter/material.dart';
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
      BuildContext context, List<Profile> profiles) {
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
    // FIXME Localization
    items.add(
        const DropdownMenuItem<int>(value: 0, child: Text('Edit Profile')));
    // FIXME Localization
    items
        .add(const DropdownMenuItem<int>(value: 1, child: Text('Add Profile')));
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
                  style: Theme.of(context).dropdownMenuTheme.textStyle,
                  softWrap: false,
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
        items: _items(context, providerProfiles.profiles),
      ),
    );
  }
}
