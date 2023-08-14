import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../application/provider_profiles.dart';
import '../../snacks/application/send_snack.dart';

/// Route for adding a new profile
class AddProfileRoute extends StatefulWidget {
  const AddProfileRoute({super.key, this.allowReturn = true});
  final bool allowReturn;

  @override
  State<AddProfileRoute> createState() => _AddProfileRouteState();
}

/// State for [AddProfileRoute]
class _AddProfileRouteState extends State<AddProfileRoute> {
  late final ProviderProfiles providerProfiles;
  late final AppLocalizations locals;
  final profileNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ibanController = TextEditingController();
  final targetController = TextEditingController();

  var isInitialized = false;

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
  void dispose() {
    profileNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ibanController.dispose();
    targetController.dispose();
    super.dispose();
  }

  /// Add a new profile using current values from the UI
  _addProfile() async {
    // TODO Don't allow empty values
    await providerProfiles.addProfile(
      profileName: profileNameController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      // TODO Check iban
      iban: ibanController.text.trim(),
      target: targetController.text.trim(),
    );

    if (context.mounted) {
      sendSnack(context: context, content: 'Added a new profile!');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.allowReturn,
      child: Scaffold(
        appBar: AppBar(
          title: Text(locals.addProfileRouteAppBarTitle),
          centerTitle: true,
          automaticallyImplyLeading: widget.allowReturn,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              // FIXME Localization
              const Text('Add a new profile'),
              TextField(
                controller: profileNameController,
                decoration: const InputDecoration(
                  // FIXME Localization
                  label: Text('Profile Name'),
                ),
              ),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  // FIXME Localization
                  label: Text('First Name'),
                ),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  // FIXME Localization
                  label: Text('Last Name'),
                ),
              ),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(
                  // FIXME Localization
                  label: Text('Target'),
                ),
              ),
              TextField(
                controller: ibanController,
                decoration: const InputDecoration(
                  // FIXME Localization
                  label: Text('IBAN'),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _addProfile();
                  },
                  // FIXME Localization
                  child: const Text('Add Profile'))
            ],
          ),
        ),
      ),
    );
  }
}
